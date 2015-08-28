require 'rails_helper'
require 'rack/test'

RSpec.describe ArticlesController, type: :controller do
  let(:valid_session) { {} }
  describe "GET #new" do
    it "assigns a new article as @article" do
      get :new, {}, valid_session
      expect(response).to redirect_to(new_user_session_path)
    end

    it "assigns a new article for a signed_in user", sign_in: true do
      get :new, {}, valid_session
      expect(assigns(:article)).to be_a_new(Article)
    end
  end
  [:show, :edit].each do |action|
    describe "#{action}", sign_in: true do
      it "should allow only the creator to #{action}" do
        article = create(:article, creator_id: controller.current_user.id)
        get action, id: article.id
        expect(response.code).to eq("200")
      end
    end

    it "should not allow others to edit" do
      article = create(:article, creator_id: create(:creator).id)
      get :edit, id: article.id
      expect(response).to redirect_to(new_user_session_path)
    end

    context "registered_user" do
      it "should not allow edit after submitting for approval", sign_in: true do
        article = create(:article, creator_id: controller.current_user.id, status: Article::Status::SUBMITTED_FOR_APPROVAL)
        get :edit, id: article.id
        expect(response).to redirect_to(root_path)
      end
    end

    context "editor/admin" do
      it "should not allow edit after publishing" do
        editor = create(:editor)
        sign_in editor

        article = create(:article, creator_id: controller.current_user.id, status: Article::Status::PUBLISHED)
        get :edit, id: article.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "update", sign_in: true do
    it "should allow update of own article" do
      article = create(:article, creator_id: controller.current_user.id)
      expect(ArticleMailer).not_to receive(:notification_to_owner)
      expect(ArticleMailer).not_to receive(:notification_to_editors)
      patch :update, id: article.id, article: {title: "new title"}, owner_id: "User:#{@user.id}"
      expect(response.code).to eq("302")
      expect(response).to redirect_to(articles_path)
    end

    it "should not create a new owner" do
      article = create(:article, creator_id: controller.current_user.id)

      patch :update, id: article.id, article: {title: "new title"}, owner_id: "User:#{@user.id}"

      expect(response.code).to eq("302")
      expect(response).to redirect_to(articles_path)
    end

    it "should not allow update of others article" do
      article = create(:article, creator_id: create(:user).id)
      expect(ArticleMailer).not_to receive(:notification_to_owner)
      expect(ArticleMailer).not_to receive(:notification_to_editors)
      patch :update, id: article.id, article: {title: "new title"}, owner_id: "User:#{@user.id}"
      expect(response).to redirect_to(root_path)
    end

    it "should update and set status as submitted_for_approval" do
      article = create(:article, creator_id: controller.current_user.id)
      article.users << @user
      mailer = double("mailer", deliver_now: "")
      expect(ArticleMailer).to receive(:notification_to_owner).with(controller.current_user, article).and_return(mailer)
      expect(ArticleMailer).to receive(:notification_to_editors).with(article).and_return(mailer)
      patch :update, id: article.id, article: {title: "new title"}, commit: ArticlesController::SUBMIT_FOR_APPROVAL, owner_id: "User:#{@user.id}"

      expect(article.reload.title).to eq("new title")
      expect(article.status).to eq(Article::Status::SUBMITTED_FOR_APPROVAL)
    end

    it "should send notification on submitting if publishing or submitting_for_approval" do
      editor = create(:editor)
      sign_in(editor)
      article = create(:article, creator_id: controller.current_user.id)
      article.users << editor
      mailer = double("mailer", deliver_now: "")
      expect(ArticleMailer).to receive(:notification_to_owner).with(controller.current_user, article).and_return(mailer)
      expect(ArticleMailer).to receive(:notification_to_editors).with(article).and_return(mailer)
      patch :update, id: article.id, article: {title: "new title"}, commit: ArticlesController::SUBMIT_FOR_APPROVAL, owner_id: "User:#{editor.id}"
    end

    context "preview" do
      it "should render preview of article", sign_in: true do
        article = create(:article, creator_id: controller.current_user.id, title: "old title")
        patch :update, id: article.id, article: {title: "new title", content: article.content}, commit: ArticlesController::PREVIEW, owner_id: "User:#{@user.id}"

        expect(assigns[:article].title).to eq("new title")
        expect(article.reload.title).to eq("old title")
        expect(assigns[:article].content).to eq(article.content)
        expect(response).to render_template("preview")
      end


      it "should create cover_image for article", sign_in: true do
        allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
        cover1 = Rack::Test::UploadedFile.new('spec/factories/test.png', 'image/png')

        article = create(:article, creator_id: controller.current_user.id, title: "old title", cover_image_attributes: CoverImage.new(cover_photo: cover1).attributes)

        cover = Rack::Test::UploadedFile.new('spec/factories/test_preview.png', 'image/png')
        patch :update, id: article.id, article: {title: "new title", content: article.content,
                                                 cover_image_attributes: {cover_photo: cover, id: article.cover_image.id}}, commit: ArticlesController::PREVIEW, owner_id: "User:#{@user.id}"

        changed_article = assigns[:article]
        expect(changed_article.title).to eq("new title")
        expect(changed_article.cover_image.cover_photo.url.split("/").count).to eq(11)
        expect(changed_article.cover_image.cover_photo.url.split("/")).to include(/test_preview.png*/)
        expect(article.reload.cover_image.cover_photo.url.split("/")).to include(/test.png*/)
      end
    end
  end

  describe "create" do
    before do
      @category = create(:category)
    end
    it "should allow creation of article", sign_in: true do
      author = create(:author, full_name: "srk")
      post :create, article: {title: "new title", content: "content", category_id: @category.id, summary: "summary"}, owner_id: "Author:#{author.id}"
      article = Article.last
      expect(article.id).not_to be_nil
      expect(article.title).to eq("new title")
      expect(article.owners.collect(&:id)).to eq([author.id])
      expect(response).to redirect_to(articles_path)
    end

    context "send_mail" do
      before do
        mailer = double("mailer", deliver_now: "")
        expect(ArticleMailer).to receive(:notification_to_owner).and_return(mailer)
        expect(ArticleMailer).to receive(:notification_to_editors).and_return(mailer)
      end

      it "should create, submit for approval and copy author_content to content", sign_in: true do
        post :create, article: {title: "new title", content: "content", category_id: @category.id, summary: "summary"}, commit: ArticlesController::SUBMIT_FOR_APPROVAL, owner_id: "User:#{@user.id}"
        article = Article.last
        expect(article.title).to eq("new title")
        expect(article.status).to eq(Article::Status::SUBMITTED_FOR_APPROVAL)
        expect(article.author_content).to eq("content")
      end

      it "should create, publish if current user is editor" do
        editor = create(:editor)
        sign_in(editor)
        post :create, article: {title: "new title", content: "content", category_id: @category.id, summary: "summary"}, commit: ArticlesController::PUBLISH, owner_id: "User:#{editor.id}"
        article = Article.last
        expect(article.status).to eq(Article::Status::PUBLISHED)
      end

      it "should create, publish if current user is admin" do
        admin = create(:administrator)
        sign_in(admin)
        post :create, article: {title: "new title", content: "content", category_id: @category.id, summary: "summary"}, commit: ArticlesController::PUBLISH, owner_id: "User:#{admin.id}"
        article = Article.last
        expect(article.status).to eq(Article::Status::PUBLISHED)
      end

      it "should send notification on submitting if publishing or submitting_for_approval" do
        editor = create(:editor)
        sign_in(editor)
        post :create, article: {title: "new title", content: "content", category_id: @category.id, summary: "summary"}, commit: ArticlesController::PUBLISH, owner_id: "User:#{editor.id}"
      end
    end

    context "preview" do
      it "should render preview of article", sign_in: true do
        post :create, article: {title: "new title", content: "content", category_id: @category.id, summary: "summary"}, commit: ArticlesController::PREVIEW, owner_id: "User:#{@user.id}"
        expect(assigns[:article].title).to eq("new title")
        expect(assigns[:article].content).to eq("content")
        expect(response).to render_template("preview")
      end
    end

    context "cover_image" do
      it "should create cover_image as preview for article", sign_in: true do
        allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
        cover = Rack::Test::UploadedFile.new('spec/factories/test_preview.png', 'image/png')
        post :create, article: {title: "new title", content: "content", category_id: @category.id, summary: "summary",
                                cover_image_attributes: {cover_photo: cover}}, commit: ArticlesController::PREVIEW, owner_id: "User:#{@user.id}"

        article = assigns[:article]
        expect(article.cover_image).not_to be_nil
        expect(CoverImage.last.cover_photo.url.split("/")).to include(/test_preview.png*/)
      end
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

      get :search, q: tag1.name, search: "tags"

      expect(assigns[:articles].class).to eq(Array)
      expect(assigns[:articles].map(&:id)).to match_array([article1.id, article3.id])
    end
  
    it "should search articles based on the category", search: true do
      category1 = create(:category, name: "science")
      category2 = create(:category, name: "history")
      category3 = create(:category, name: "politics")
      article1 = create(:article, content: "article1", category_id: category1.id, status: Article::Status::PUBLISHED)
      article2 = create(:article, content: "article2", category_id: category3.id, status: Article::Status::PUBLISHED)
      article3 = create(:article, content: "article3", category_id: category2.id, status: Article::Status::PUBLISHED)
      Article.__elasticsearch__.refresh_index!

      get :search, q: category1.name, search: "category"

      expect(assigns[:articles].class).to eq(Array)
      expect(assigns[:articles].map(&:id)).to match_array([article1.id])
    end
  end

  context "index" do
    it "should list current user articles if registered_user" do
      registered_user = create(:user)
      sign_in registered_user
      article1 = create(:article, creator_id: registered_user.id)
      article2 = create(:article, creator_id: create(:user).id)
      article3 = create(:article, creator_id: registered_user.id)
      ArticleOwner.create(article: article1, owner: registered_user)

      get :index

      expect(assigns[:articles]).to match_array([article1])
      expect(assigns[:proxy_articles]).to match_array([article3])
    end

    it "should list current user articles and all articles submitted for approval if editor" do
      editor = create(:editor)
      sign_in editor
      article1 = create(:article, creator_id: editor.id)
      article2 = create(:article, creator_id: create(:user).id, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      article3 = create(:article, creator_id: create(:user).id, status: Article::Status::DRAFT)
      article4 = create(:article, creator_id: create(:user).id, status: Article::Status::PUBLISHED)
      article5 = create(:article, creator_id: editor.id)

      get :index

      expect(assigns[:proxy_articles]).to match_array([article1, article5])
      expect(assigns[:articles_submitted]).to match_array([article2])
    end

    it "should list current user articles and all articles submitted for approval if administrator" do
      administrator = create(:administrator)
      sign_in administrator
      article1 = create(:article, creator_id: administrator.id)
      article2 = create(:article, creator_id: create(:user).id, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      article3 = create(:article, creator_id: create(:user).id, status: Article::Status::DRAFT)
      article4 = create(:article, creator_id: create(:user).id, status: Article::Status::PUBLISHED)
      article5 = create(:article, creator_id: administrator.id)

      get :index

      expect(assigns[:proxy_articles]).to match_array([article1, article5])
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
      article_owner = ArticleOwner.create(article: article, owner: @admin)
      mailer = double("mailer", deliver_now: "")
      expect(ArticleMailer).to receive(:published_notification_to_owner).with(User.find(article_owner.owner_id), article).and_return(mailer)
      expect(ArticleMailer).to receive(:published_notification_to_editors).with(article).and_return(mailer)

      patch :approve, id: article.id, article: {title: "title by admin"}, commit: ArticlesController::PUBLISH, owner_id: "User:#{@admin.id}"

      expect(article.reload.title).to eq("title by admin")
      expect(article.status).to eq(Article::Status::PUBLISHED)
      expect(response.code).to eq("302")
      expect(response).to redirect_to(articles_path)
    end

    it "should create cover_image for article", admin_sign_in: true do
      allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
      cover = Rack::Test::UploadedFile.new('spec/factories/test.png', 'image/png')
      article = create(:article, creator_id: controller.current_user.id, title: "old title", cover_image_attributes: CoverImage.new(cover_photo: cover).attributes, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      article.users << @admin

      patch :approve, id: article.id, article: {title: "new title", content: article.content, cover_image_attributes: {id: article.cover_image.id}}, commit: ArticlesController::PUBLISH, owner_id: "User:#{@admin.id}"

      changed_article = article.reload
      expect(changed_article.reload.cover_image.cover_photo.url.split("/")).to include(/test.png*/)
    end

    it "should render approve_form on error", admin_sign_in: true do
      article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      expect(ArticleMailer).not_to receive(:published_notification_to_owner)

      patch :approve, id: article.id, article: {title: ""}, commit: ArticlesController::PUBLISH, owner_id: "User:#{@admin.id}"

      expect(article.reload.status).not_to eq(Article::Status::PUBLISHED)
      expect(response).to render_template("approve_form")
    end

    it "should save as draft and not publish", admin_sign_in: true do
      article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      expect(ArticleMailer).not_to receive(:published_notification_to_owner)
      patch :approve, id: article.id, article: {title: "title by admin"}, commit: ArticlesController::SAVE, owner_id: "User:#{@admin.id}"

      expect(article.reload.title).to eq("title by admin")
      expect(article.status).to eq(Article::Status::SUBMITTED_FOR_APPROVAL)
      expect(response.code).to eq("302")
    end

    context "preview" do
      it "should render preview of article", admin_sign_in: true do
        article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)

        patch :approve, id: article.id, article: {title: "title by admin"}, commit: ArticlesController::PREVIEW
        expect(assigns[:article].title).to eq("title by admin")
        expect(response).to render_template("preview")
      end
    end
  end

  context "show" do
    context "general user" do
      it "should render show only articles that are published" do
        article = create(:article, status: Article::Status::PUBLISHED)
        get :show, id: article.id

        expect(response.code).to eq("200")
      end

      it "should not render show articles that are draft/submitted_for_approval" do
        article = create(:article, status: Article::Status::DRAFT)
        get :show, id: article.id

        expect(response).to redirect_to(new_user_session_path)
      end

      it "should not render show articles that are draft/submitted_for_approval" do
        article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)
        get :show, id: article.id

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "creator" do
      it "should show own article when it is in any status", sign_in: true do
        article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL, creator_id: controller.current_user.id)
        get :show, id: article.id

        expect(response.code).to eq("200")
      end

      it "should show own article when it is in any status", sign_in: true do
        article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL, creator_id: create(:user).id)
        get :show, id: article.id

        expect(response).to redirect_to(root_path)
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

        expect(response).to redirect_to(root_path)
      end
    end
  end

  context "home_page_order_update" do
    it "should allow only admin to update the home_page_order of article" do
      article = create(:article)
      patch :home_page_order_update, id: article.id, article: {home_page_order: 1}

      expect(response).to redirect_to(new_user_session_path)
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
