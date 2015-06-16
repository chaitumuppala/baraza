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
      expect(assigns[:articles].map(&:id)).to match_array([article1.id.to_s, article3.id.to_s])
    end
  
    it "should search articles based on the categories", search: true do
      category1 = create(:category, name: "science")
      category2 = create(:category, name: "history")
      category3 = create(:category, name: "politics")
      article1 = create(:article, content: "article1")
      article2 = create(:article, content: "article2")
      article3 = create(:article, content: "article3")
      article1.categories << [category1, category2]
      article2.categories << category3
      article3.categories << [category1, category3]
      Article.__elasticsearch__.import force: true
      Article.__elasticsearch__.refresh_index!

      get :search, q: category1.name, search: "category"

      expect(assigns[:articles].class).to eq(Array)
      expect(assigns[:articles].map(&:id)).to match_array([article1.id.to_s, article3.id.to_s])
    end
  end
end
