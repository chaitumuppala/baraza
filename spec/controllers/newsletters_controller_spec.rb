require 'rails_helper'

describe NewslettersController do
  before do
    sign_in(create(:administrator))
  end
  context "update" do
    it "should update and approve the newsletter if params[:commit] is PUBLISH" do
      newsletter = create(:newsletter)
      category = create(:category)
      cn = CategoryNewsletter.create(newsletter: newsletter, category: category)
      patch :update, "newsletter"=>{
                       "category_newsletters_attributes"=>[{"position_in_newsletter"=>"100", "category_id"=>category.id, "newsletter_id"=>newsletter.id, "id" => cn.id}], "articles_attributes"=>[],},
                       "commit"=>NewslettersController::PUBLISH, "id"=>newsletter.id

      expect(CategoryNewsletter.where(newsletter: newsletter, category: category).first.position_in_newsletter).to eq(100)
      expect(newsletter.reload.status).to eq(Newsletter::Status::PUBLISHED)
    end

    it "should remove article params which dont have ids in article_ids" do
      newsletter = create(:newsletter)
      category = create(:category)
      cn = CategoryNewsletter.create(newsletter: newsletter, category: category)
      article1 = create(:article)
      article2 = create(:article)
      article3 = create(:article)
      newsletter.articles << [article1, article2, article3]
      patch :update, "newsletter"=>{"article_ids"=>[article1.id],
                                    "articles_attributes"=>[{"position_in_newsletter"=>"1", "id"=>article1.id}, {"position_in_newsletter"=>"2", "id"=>article2.id}, {"position_in_newsletter"=>"3", "id"=>article3.id}]},
                                    "commit"=>"Approve", "id"=>newsletter.id

      expect(newsletter.reload.articles).to eq([article1])
    end
  end

  context "edit" do
    it "should allow to edit only if newsletter is in draft state" do
      newsletter = create(:newsletter, status: Newsletter::Status::DRAFT)
      get :edit, id: newsletter.id

      expect(response).to render_template("edit")
    end

    it "should not allow to edit only if newsletter is in approved/published state" do
      newsletter = create(:newsletter, status: Newsletter::Status::APPROVED)
      get :edit, id: newsletter.id

      expect(response).not_to render_template("edit")
    end
  end

  context "create" do
    it "should create and redirect to edit_newsletter path" do
      post :create, newsletter: {name: "june"}

      newsletter = Newsletter.last
      expect(response).to redirect_to(edit_newsletter_path(newsletter))
    end

    it "should render new if error" do
      post :create, newsletter: {name: ""}

      expect(response).to render_template("new")
    end
  end
end
