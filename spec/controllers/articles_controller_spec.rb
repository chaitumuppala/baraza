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

      it "should not allow others to #{action}" do
        article = create(:article, user_id: create(:user).id)
        get action, id: article.id
        expect(response.code).to eq("403")
      end
    end
  end

  describe "update", sign_in: true do
    it "should allow update of own article" do
      article = create(:article, user_id: controller.current_user.id)
      patch :update, id: article.id, article: {title: "new title"}
      expect(response.code).to eq("302")
    end

    it "should not allow update of others article" do
      article = create(:article, user_id: create(:user).id)
      patch :update, id: article.id, article: {title: "new title"}
      expect(response.code).to eq("403")
    end
  end

  describe "create", sign_in: true do
    it "should allow creation of article" do
      post :create, article: {title: "new title"}
      article = Article.last
      expect(article.id).not_to be_nil
      expect(article.title).to eq("new title")
    end
  end
end
