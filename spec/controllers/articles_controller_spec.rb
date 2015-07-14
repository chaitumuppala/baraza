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

    context "registered_user" do
      it "should not allow edit after submitting for approval", sign_in: true do
        article = create(:article, user_id: controller.current_user.id, status: Article::Status::SUBMITTED_FOR_APPROVAL)
        get :edit, id: article.id
        expect(response.code).to eq("403")
      end
    end

    context "editor/admin" do
      it "should not allow edit after publishing" do
        editor = create(:editor)
        sign_in editor

        article = create(:article, user_id: controller.current_user.id, status: Article::Status::PUBLISHED)
        get :edit, id: article.id
        expect(response.code).to eq("403")
      end
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

    it "should update and set status as submitted_for_approval" do
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
      post :create, article: {title: "new title", content: "content", category_ids: [@category.id], summary: "summary"}
      article = Article.last
      expect(article.id).not_to be_nil
      expect(article.title).to eq("new title")
    end

    it "should create, submit for approval and copy author_content to content", sign_in: true do
      post :create, article: {title: "new title", content: "content", category_ids: [@category.id], summary: "summary"}, commit: ArticlesController::SUBMIT_FOR_APPROVAL
      article = Article.last
      expect(article.title).to eq("new title")
      expect(article.status).to eq(Article::Status::SUBMITTED_FOR_APPROVAL)
      expect(article.author_content).to eq("content")
    end

    it "should create, publish if current user is editor" do
      sign_in(create(:editor))
      post :create, article: {title: "new title", content: "content", category_ids: [@category.id], summary: "summary"}, commit: ArticlesController::PUBLISH
      article = Article.last
      expect(article.status).to eq(Article::Status::PUBLISHED)
    end

    it "should create, publish if current user is admin" do
      sign_in(create(:administrator))
      post :create, article: {title: "new title", content: "content", category_ids: [@category.id], summary: "summary"}, commit: ArticlesController::PUBLISH
      article = Article.last
      expect(article.status).to eq(Article::Status::PUBLISHED)
    end

    it "should send notification on submitting if publishing or submitting_for_approval" do
      editor = create(:editor)
      sign_in(editor)
      mailer = double("mailer", deliver_later: "")
      expect(ArticleMailer).to receive(:notification_to_creator).and_return(mailer)
      expect(ArticleMailer).to receive(:notification_to_editors).and_return(mailer)
      post :create, article: {title: "new title", content: "content", category_ids: [@category.id], summary: "summary"}, commit: ArticlesController::PUBLISH
    end
  end

  context "search" do
    it "should search articles based on the tags", search: true do
      tag1 = create(:tag, name: "science")
      tag2 = create(:tag, name: "history")
      tag3 = create(:tag, name: "politics")
      article1 = create(:article, tag_list: "#{tag1.name},#{tag2.name}", content: "article1", status: Article::Status::PUBLISHED)
      article2 = create(:article, tag_list: tag3.name, content: "article2", status: Article::Status::PUBLISHED)
      article3 = create(:article, tag_list: "#{tag1.name},#{tag3.name}", content: "article3", status: Article::Status::PUBLISHED)
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
      article1 = create(:article, content: "article1", category_ids: [category1.id, category2.id], status: Article::Status::PUBLISHED)
      article2 = create(:article, content: "article2", category_ids: [category3.id], status: Article::Status::PUBLISHED)
      article3 = create(:article, content: "article3", category_ids: [category1.id, category3.id], status: Article::Status::PUBLISHED)
      Article.__elasticsearch__.refresh_index!

      get :search, q: category1.name, search: "category"

      expect(assigns[:articles].class).to eq(Array)
      expect(assigns[:articles].map(&:id)).to match_array([article1.id, article3.id])
    end
  end

  context "index" do
    it "should list current user articles if registered_user" do
      registered_user = create(:user)
      sign_in registered_user
      article1 = create(:article, user_id: registered_user.id)
      article2 = create(:article, user_id: create(:user).id)
      article3 = create(:article, user_id: registered_user.id)

      get :index

      expect(assigns[:articles]).to match_array([article1, article3])
    end

    it "should list current user articles and all articles submitted for approval if editor" do
      editor = create(:editor)
      sign_in editor
      article1 = create(:article, user_id: editor.id)
      article2 = create(:article, user_id: create(:user).id, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      article3 = create(:article, user_id: create(:user).id, status: Article::Status::DRAFT)
      article4 = create(:article, user_id: create(:user).id, status: Article::Status::PUBLISHED)
      article5 = create(:article, user_id: editor.id)

      get :index

      expect(assigns[:articles]).to match_array([article1, article5])
      expect(assigns[:articles_submitted]).to match_array([article2])
    end

    it "should list current user articles and all articles submitted for approval if administrator" do
      administrator = create(:administrator)
      sign_in administrator
      article1 = create(:article, user_id: administrator.id)
      article2 = create(:article, user_id: create(:user).id, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      article3 = create(:article, user_id: create(:user).id, status: Article::Status::DRAFT)
      article4 = create(:article, user_id: create(:user).id, status: Article::Status::PUBLISHED)
      article5 = create(:article, user_id: administrator.id)

      get :index

      expect(assigns[:articles]).to match_array([article1, article5])
      expect(assigns[:articles_submitted]).to match_array([article2])
    end
  end

  context "approve_form" do
    it "should render approve article form", editor_sign_in: true do
      article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      get :approve_form, id: article.id

      expect(response).to render_template("approve_form")
      expect(assigns(:article)).to eq(article)
    end
  end

  context "approve" do
    it "should allow update of own article", admin_sign_in: true do
      article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      mailer = double("mailer", deliver_later: "")
      expect(ArticleMailer).to receive(:published_notification_to_creator).with(User.find(article.user_id), article).and_return(mailer)

      patch :approve, id: article.id, article: {title: "title by admin"}, commit: ArticlesController::PUBLISH

      expect(article.reload.title).to eq("title by admin")
      expect(article.status).to eq(Article::Status::PUBLISHED)
      expect(response.code).to eq("302")
    end

    it "should render approve_form on error", admin_sign_in: true do
      article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      expect(ArticleMailer).not_to receive(:published_notification_to_creator)

      patch :approve, id: article.id, article: {title: ""}, commit: ArticlesController::PUBLISH

      expect(article.reload.status).not_to eq(Article::Status::PUBLISHED)
      expect(response).to render_template("approve_form")
    end

    it "should save as draft and not publish", admin_sign_in: true do
      article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      expect(ArticleMailer).not_to receive(:published_notification_to_creator)
      patch :approve, id: article.id, article: {title: "title by admin"}, commit: ArticlesController::SAVE

      expect(article.reload.title).to eq("title by admin")
      expect(article.status).to eq(Article::Status::SUBMITTED_FOR_APPROVAL)
      expect(response.code).to eq("302")
    end
  end

  context "show" do
    context "set_meta_tags" do
      it "should set_meta_tag" do
        article = create(:article, status: Article::Status::PUBLISHED)
        expect(controller).to receive(:set_meta_tags).with({site: "Baraza",
                                                            title: article.title,
                                                            separator: "|",
                                                            og: {
                                                                site: "Baraza",
                                                                title: article.title,
                                                                url: article_url(article),
                                                                description: article.summary,
                                                                image: article.cover_image.url
                                                            },
                                                            twitter: {
                                                                card: "summary",
                                                                site: "Baraza",
                                                                title: article.title,
                                                                url: article_url(article),
                                                                description: article.summary,
                                                                image: article.cover_image.url
                                                            }
                                                           })


        get :show, id: article.id
      end
    end
    context "general user" do
      it "should render show only articles that are published" do
        article = create(:article, status: Article::Status::PUBLISHED)
        get :show, id: article.id

        expect(response.code).to eq("200")
      end

      it "should not render show articles that are draft/submitted_for_approval" do
        article = create(:article, status: Article::Status::DRAFT)
        get :show, id: article.id

        expect(response.code).to eq("403")
      end

      it "should not render show articles that are draft/submitted_for_approval" do
        article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)
        get :show, id: article.id

        expect(response.code).to eq("403")
      end
    end

    context "creator" do
      it "should show own article when it is in any status", sign_in: true do
        article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL, user_id: controller.current_user.id)
        get :show, id: article.id

        expect(response.code).to eq("200")
      end

      it "should show own article when it is in any status", sign_in: true do
        article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL, user_id: create(:user).id)
        get :show, id: article.id

        expect(response.code).to eq("403")
      end
    end

    context "editor/admin" do
      it "should show any article not draft", editor_sign_in: true do
        article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)
        get :show, id: article.id

        expect(response.code).to eq("200")
      end

      it "should show any article not draft", editor_sign_in: true do
        article = create(:article, status: Article::Status::PUBLISHED)
        get :show, id: article.id

        expect(response.code).to eq("200")
      end

      it "should not show any article draft", editor_sign_in: true do
        article = create(:article, status: Article::Status::DRAFT)
        get :show, id: article.id

        expect(response.code).to eq("403")
      end
    end
  end

  context "home_page_order_update" do
    it "should allow only admin to update the home_page_order of article" do
      article = create(:article)
      patch :home_page_order_update, id: article.id, article: {home_page_order: 1}

      expect(response.code).to eq("403")
    end

    it "should update the home_page_order of article", admin_sign_in: true do
      article_at_order_one = create(:article, home_page_order: 1)
      article = create(:article)
      patch :home_page_order_update, id: article.id, article: {home_page_order: 1}

      expect(response).to redirect_to("/?configure_home=true")
      expect(article.reload.home_page_order).to eq(1)
      expect(article_at_order_one.reload.home_page_order).to be_nil
    end
  end
end
