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
end
