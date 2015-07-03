require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:valid_session) { {} }
  describe "GET #new" do
    it "assigns a new article as @article" do
      get :new, {}, valid_session
      expect(response.code).to eq("403")
    end

    it "assigns a new article for a signed_in user", sign_in: true do
      get :new, {}, valid_session
      expect(assigns(:article)).to be_a_new(Article)
    end
  end
  [:show, :edit].each do |action|
    describe "#{action}", sign_in: true do
      it "should allow only the creator to #{action}" do
        article = create(:article, user_id: controller.current_user.id)
        get action, id: article.id
        expect(response.code).to eq("200")
      end
    end

    it "should not allow others to edit" do
      article = create(:article, user_id: create(:user).id)
      get :edit, id: article.id
      expect(response.code).to eq("403")
    end

    it "should not allow edit after submitting for approval", sign_in: true do
      article = create(:article, user_id: controller.current_user.id, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      get :edit, id: article.id
      expect(response.code).to eq("403")
    end
  end

  describe "update", sign_in: true do
    it "should allow update of own article" do
      article = create(:article, user_id: controller.current_user.id)
      expect(ArticleMailer).not_to receive(:notification_to_creator)
      expect(ArticleMailer).not_to receive(:notification_to_editors)
      patch :update, id: article.id, article: {title: "new title"}
      expect(response.code).to eq("302")
    end

    it "should not allow update of others article" do
      article = create(:article, user_id: create(:user).id)
      expect(ArticleMailer).not_to receive(:notification_to_creator)
      expect(ArticleMailer).not_to receive(:notification_to_editors)
      patch :update, id: article.id, article: {title: "new title"}
      expect(response.code).to eq("403")
    end

    it "should update and set status as unapproved" do
      article = create(:article, user_id: controller.current_user.id)
      patch :update, id: article.id, article: {title: "new title"}, commit: ArticlesController::SUBMIT_FOR_APPROVAL

      expect(article.reload.title).to eq("new title")
      expect(article.status).to eq(Article::Status::SUBMITTED_FOR_APPROVAL)
    end

    it "should send notification on submitting if publishing or submitting_for_approval" do
      editor = create(:editor)
      sign_in(editor)
      article = create(:article, user_id: controller.current_user.id)
      mailer = double("mailer", deliver_later: "")
      expect(ArticleMailer).to receive(:notification_to_creator).with(controller.current_user, article).and_return(mailer)
      expect(ArticleMailer).to receive(:notification_to_editors).with(article).and_return(mailer)
      patch :update, id: article.id, article: {title: "new title"}, commit: ArticlesController::SUBMIT_FOR_APPROVAL
    end
  end

  describe "create" do
    before do
      @category = create(:category)
    end
    it "should allow creation of article", sign_in: true do
      post :create, article: {title: "new title", content: "content", category_ids: [@category.id]}
      article = Article.last
      expect(article.id).not_to be_nil
      expect(article.title).to eq("new title")
    end

    it "should create, submit for approval and copy author_content to content", sign_in: true do
      post :create, article: {title: "new title", content: "content", category_ids: [@category.id]}, commit: ArticlesController::SUBMIT_FOR_APPROVAL
      article = Article.last
      expect(article.title).to eq("new title")
      expect(article.status).to eq(Article::Status::SUBMITTED_FOR_APPROVAL)
      expect(article.author_content).to eq("content")
    end

    it "should create, publish if current user is editor" do
      sign_in(create(:editor))
      post :create, article: {title: "new title", content: "content", category_ids: [@category.id]}, commit: ArticlesController::PUBLISH
      article = Article.last
      expect(article.status).to eq(Article::Status::PUBLISHED)
    end

    it "should send notification on submitting if publishing or submitting_for_approval" do
      editor = create(:editor)
      sign_in(editor)
      mailer = double("mailer", deliver_later: "")
      expect(ArticleMailer).to receive(:notification_to_creator).and_return(mailer)
      expect(ArticleMailer).to receive(:notification_to_editors).and_return(mailer)
      post :create, article: {title: "new title", content: "content", category_ids: [@category.id]}, commit: ArticlesController::PUBLISH
    end
  end

  context "search" do
    it "should search articles based on the tags", search: true do
      tag1 = create(:tag, name: "science")
      tag2 = create(:tag, name: "history")
      tag3 = create(:tag, name: "politics")
      article1 = create(:article, tag_list: "#{tag1.name},#{tag2.name}", content: "article1")
      article2 = create(:article, tag_list: tag3.name, content: "article2")
      article3 = create(:article, tag_list: "#{tag1.name},#{tag3.name}", content: "article3")
      Article.__elasticsearch__.import force: true
      Article.__elasticsearch__.refresh_index!

      get :search, q: tag1.name, search: "tag"

      expect(assigns[:articles].class).to eq(Array)
      expect(assigns[:articles].map(&:id)).to match_array([article1.id, article3.id])
      expect(assigns[:articles].map(&:cover_image)).not_to be_empty
    end
  
    it "should search articles based on the categories", search: true do
      category1 = create(:category, name: "science")
      category2 = create(:category, name: "history")
      category3 = create(:category, name: "politics")
      article1 = create(:article, content: "article1", category_ids: [category1.id, category2.id])
      article2 = create(:article, content: "article2", category_ids: [category3.id])
      article3 = create(:article, content: "article3", category_ids: [category1.id, category3.id])
      Article.__elasticsearch__.refresh_index!

      get :search, q: category1.name, search: "category"

      expect(assigns[:articles].class).to eq(Array)
      expect(assigns[:articles].map(&:id)).to match_array([article1.id, article3.id])
    end
  end

  context "index" do
    it "should list current user articles" do
      registered_user = create(:user)
      sign_in registered_user
      article1 = create(:article, user_id: registered_user.id)
      article2 = create(:article, user_id: create(:user).id)
      article3 = create(:article, user_id: registered_user.id)

      get :index

      expect(assigns[:articles]).to match_array([article1, article3])
    end
  end
end
