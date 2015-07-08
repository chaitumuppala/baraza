require "rails_helper"

describe ArticleIndexJob do
  context "perform" do
    it "should index the article" do
      article = create(:article, id: 100)
      expect(Article).to receive(:find).with(article.id).and_return(article)
      expect(article).to receive(:index_current_document_values)
      ArticleIndexJob.new(article.id).perform
    end
  end
end