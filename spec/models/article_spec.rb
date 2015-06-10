require 'rails_helper'

describe Article do
  context "tag_list" do
    it "should list the tags as comma separated string" do
      tag1 = create(:tag, name: "history")
      tag2 = create(:tag, name: "science")
      article = create(:article)
      article.tags << [tag1, tag2]

      expect(article.tag_list).to eq("history,science")
    end
  end

  context "tag_list=" do
    it "should add tags of the given names" do
      article = create(:article, tag_list: "history,science")
      expect(article.tag_list).to eq("history,science")
    end

    it "should not create same tag again" do
      tag1 = create(:tag, name: "history")
      article = create(:article)
      article.tags << tag1
      article.update_attributes(tag_list: "history,science")
      expect(article.tags.count).to eq(2)
    end

    it "should delete tags" do
      tag1 = create(:tag, name: "history")
      tag2 = create(:tag, name: "science")
      article = create(:article)
      article.tags << [tag1, tag2]
      article.update_attributes(tag_list: "history")
      expect(article.reload.tags.count).to eq(1)
      expect(Tag.count).to eq(2)
    end
  end

  context "search_by_tag", search: true do
    it "should return articles of the given tag_name" do
      tag1 = create(:tag, name: "history")
      tag2 = create(:tag, name: "science")
      article1 = create(:article)
      article2 = create(:article)
      article1.tags << [tag1, tag2]
      article2.tags << tag1

      Article.import
      Article.__elasticsearch__.refresh_index!

      expect(Article.search_by_tag(tag2.name).collect(&:id)).to eq([article1.id.to_s])
    end
  end

  context "as_indexed_json" do
    it "should index including tag names" do
      tag1 = create(:tag, name: "history")
      tag2 = create(:tag, name: "science")
      article = create(:article)
      article.tags << [tag1, tag2]

      expect(article.as_indexed_json).to eq({"id"=>article.id,
                                             "title"=>article.title,
                                             "content"=>article.content,
                                             "tags"=>[{"name"=>tag1.name}, {"name"=>tag2.name}]})
    end
  end

  context "index_name" do
    it "should set the environment along with index" do
      expect(Article.index_name).to eq("articles_#{Rails.env}")
    end
  end

  context "mapping" do
    it "should set snowball analyzer for title and content" do
      mapping = Article.mapping.to_hash[:article][:properties]
      expect(mapping[:title][:analyzer]).to eq("snowball")
      expect(mapping[:content][:analyzer]).to eq("snowball")
    end
  end
end
