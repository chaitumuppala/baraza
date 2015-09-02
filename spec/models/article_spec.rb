# == Schema Information
#
# Table name: articles
#
#  id                     :integer          not null, primary key
#  title                  :string(255)      not null
#  content                :text(65535)      not null
#  creator_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  top_story              :boolean
#  newsletter_id          :integer
#  position_in_newsletter :integer
#  status                 :string(255)      default("draft")
#  author_content         :text(65535)
#  summary                :text(65535)      not null
#  home_page_order        :integer
#  date_published         :datetime
#  category_id            :integer          not null
#
# Indexes
#
#  index_articles_on_category_id  (category_id)
#  index_articles_on_creator_id   (creator_id)
#

require 'rails_helper'

RSpec.describe Article, type: :model do
  context 'tag_list' do
    it 'should list the tags as comma separated string' do
      tag1 = create(:tag, name: 'history')
      tag2 = create(:tag, name: 'science')
      article = create(:article)
      article.tags << [tag1, tag2]

      expect(article.tag_list).to eq('history,science')
    end
  end

  context 'tag_list=' do
    it 'should add tags of the given names' do
      article = create(:article, tag_list: 'history,science')
      expect(article.tag_list).to eq('history,science')
    end

    it 'should not create same tag again' do
      tag1 = create(:tag, name: 'history')
      article = create(:article)
      article.tags << tag1
      article.update_attributes(tag_list: 'history,science')
      expect(article.tags.count).to eq(2)
    end

    it 'should delete tags' do
      tag1 = create(:tag, name: 'history')
      tag2 = create(:tag, name: 'science')
      article = create(:article)
      article.tags << [tag1, tag2]
      article.update_attributes(tag_list: 'history')
      expect(article.reload.tags.count).to eq(1)
      expect(Tag.count).to eq(2)
    end
  end

  context 'search_by_tags', search: true do
    it 'should return articles of the given tag_name' do
      tag1 = create(:tag, name: 'history')
      tag2 = create(:tag, name: 'science')
      article1 = create(:article, content: 'article1', tag_list: "#{tag1.name},#{tag2.name}", status: Article::Status::PUBLISHED)
      article2 = create(:article, content: 'article2', tag_list: tag1.name)

      Article.__elasticsearch__.refresh_index!

      expect(Article.search_by_tags(tag2.name).collect(&:id)).to eq([article1.id])
    end

    it 'should return articles of the given  new tag_name' do
      tag1 = create(:tag, name: 'history')
      article1 = create(:article, content: 'article1', tag_list: "#{tag1.name},science", status: Article::Status::PUBLISHED)
      article2 = create(:article, content: 'article2', tag_list: tag1.name)

      Article.__elasticsearch__.refresh_index!

      expect(Article.search_by_tags('science').collect(&:id)).to eq([article1.id])
    end
  end

  context 'as_indexed_json' do
    it 'should index including tag names, category names' do
      tag1 = create(:tag, name: 'history')
      tag2 = create(:tag, name: 'science')
      category = create(:category)
      article = create(:article, category_id: category.id, status: Article::Status::PUBLISHED)
      date = Time.current
      article.update_attributes(date_published: date)
      article.tags << [tag1, tag2]

      expect(article.as_indexed_json.keys).to eq(%w(id
                                                    title
                                                    content
                                                    status
                                                    date_published
                                                    tags
                                                    category))
    end
  end

  context 'index_name' do
    it 'should set the environment along with index' do
      expect(Article.index_name).to eq("articles_#{Rails.env}")
    end
  end

  context 'mapping' do
    it 'should set snowball analyzer for title and content' do
      mapping = Article.mapping.to_hash[:article][:properties]
      expect(mapping[:title][:analyzer]).to eq('snowball')
      expect(mapping[:content][:analyzer]).to eq('snowball')
      expect(mapping[:status]).to eq(index: 'not_analyzed', type: 'string')
      expect(mapping[:tags][:properties]).to eq(name: { index: 'not_analyzed', type: 'string' })
      expect(mapping[:category][:properties]).to eq(name: { index: 'not_analyzed', type: 'string' })
    end
  end

  context 'index_document' do
    context 'tags' do
      it 'should update document on adding tags through tag_list', search: true do
        tag1 = create(:tag, name: 'history')
        tag2 = create(:tag, name: 'science')
        article = create(:article, tag_list: tag1.name, status: Article::Status::PUBLISHED)

        article.update_attributes(tag_list: "#{tag1.name},#{tag2.name},abcd")
        Article.__elasticsearch__.refresh_index!
        expect(Article.search_by_tags(tag1.name).collect(&:id)).to eq([article.id])
        expect(Article.search_by_tags(tag2.name).collect(&:id)).to eq([article.id])
        expect(Article.search_by_tags('abcd').collect(&:id)).to eq([article.id])
      end

      it 'should update document on removing tags through tag_list', search: true do
        tag1 = create(:tag, name: 'history')
        tag2 = create(:tag, name: 'science')
        article = create(:article, status: Article::Status::PUBLISHED)
        article.tags << [tag1, tag2]

        article.update_attributes(tag_list: "#{tag1.name}")
        Article.__elasticsearch__.refresh_index!
        expect(Article.search_by_tags(tag1.name).collect(&:id)).to eq([article.id])
        expect(Article.search_by_tags(tag2.name).collect(&:id)).to eq([])
      end
    end

    context 'category' do
      it 'should update document on adding category through category_id', search: true do
        category1 = create(:category, name: 'history')
        category2 = create(:category, name: 'science')
        article = create(:article, category_id: category1.id, status: Article::Status::PUBLISHED)

        article.update_attributes(category_id: category2.id)
        Article.__elasticsearch__.refresh_index!
        expect(Article.search_by_category(category1.name).collect(&:id)).to eq([])
        expect(Article.search_by_category(category2.name).collect(&:id)).to eq([article.id])
      end
    end
  end

  context 'search_by_category', search: true do
    it 'should return articles of the given category name' do
      category1 = create(:category, name: 'history')
      category2 = create(:category, name: 'science')
      article1 = create(:article, content: 'article1', category_id: category2.id, status: Article::Status::PUBLISHED)
      article2 = create(:article, content: 'article1', category_id: category2.id, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      article3 = create(:article, content: 'article1', category_id: category2.id, status: Article::Status::DRAFT)
      article4 = create(:article, content: 'article2', category_id: category1.id)

      Article.__elasticsearch__.refresh_index!

      expect(Article.search_by_category(category2.name).collect(&:id)).to eq([article1.id])
    end

    it 'should sort results by date_published' do
      category1 = create(:category, name: 'history')
      category2 = create(:category, name: 'science')
      article1 = create(:article, content: 'article1', category_id: category2.id, status: Article::Status::PUBLISHED)
      article2 = create(:article, content: 'article1', category_id: category2.id, status: Article::Status::PUBLISHED)
      article3 = create(:article, content: 'article1', category_id: category2.id, status: Article::Status::PUBLISHED)
      article1.update_attributes(date_published: Date.today)
      article2.update_attributes(date_published: 10.days.ago)
      article3.update_attributes(date_published: Date.yesterday)
      Article.__elasticsearch__.refresh_index!

      expect(Article.search_by_category(category2.name).collect(&:id)).to eq([article1.id, article3.id, article2.id])
    end
  end

  context 'search_by_all', search: true do
    it 'should return articles of the given name' do
      category1 = create(:category, name: 'history')
      category2 = create(:category, name: 'culture')
      tag = create(:category, name: 'tag1')
      article1 = create(:article, content: 'article1', category_id: category1.id, tag_list: tag.name, status: Article::Status::PUBLISHED)
      article2 = create(:article, content: 'article2', category_id: category1.id, status: Article::Status::PUBLISHED)
      article3 = create(:article, content: 'article2', category_id: category1.id, status: Article::Status::DRAFT)

      Article.__elasticsearch__.refresh_index!

      expect(Article.search_by_all('article1').collect(&:id)).to eq([article1.id])
      expect(Article.search_by_all(tag.name).collect(&:id)).to eq([article1.id])

      expect(Article.search_by_all('article2').collect(&:id)).to eq([article2.id])

      expect(Article.search_by_all(category1.name).collect(&:id)).to match_array([article1.id, article2.id])
    end

    it 'should sort results by date_published' do
      category1 = create(:category, name: 'history')
      category2 = create(:category, name: 'science')
      article1 = create(:article, content: 'article1', category_id: category2.id, status: Article::Status::PUBLISHED)
      article2 = create(:article, content: 'article1', category_id: category2.id, status: Article::Status::PUBLISHED)
      article3 = create(:article, content: 'article1', category_id: category2.id, status: Article::Status::PUBLISHED)
      article1.update_attributes(date_published: Date.today)
      article2.update_attributes(date_published: 10.days.ago)
      article3.update_attributes(date_published: Date.yesterday)
      Article.__elasticsearch__.refresh_index!

      expect(Article.search_by_all(category2.name).collect(&:id)).to eq([article1.id, article3.id, article2.id])
    end
  end

  context 'delayed_job' do
    it 'should asynchronously index the document' do
      Delayed::Worker.delay_jobs = true

      expect do
        create(:article, content: 'article1')
      end.to change { Delayed::Job.count }.from(0).to(1)
    end

    it 'should index using article index job' do
      article_id = 100
      mock_article_index_job = double('article_index_job')
      expect(ArticleIndexJob).to receive(:new).with(article_id).and_return(mock_article_index_job)
      expect(Delayed::Job).to receive(:enqueue).with(mock_article_index_job)
      create(:article, content: 'article1', id: article_id)
    end
  end

  context 'validation' do
    it 'should validate presence of title' do
      expect(build(:article, title: nil)).not_to be_valid
    end
    it 'should validate presence of content' do
      expect(build(:article, content: nil)).not_to be_valid
    end
    it 'should validate presence of category' do
      expect(build(:article, category_id: nil)).not_to be_valid
    end

    it 'should validate presence of summary' do
      expect(build(:article, summary: '')).not_to be_valid
    end

    it 'should validate uniqueness of home_page_order' do
      create(:article, home_page_order: 1)
      expect(build(:article, home_page_order: 1)).not_to be_valid
    end
  end

  context 'after_save' do
    it 'should set date_published on create and publishing article' do
      article = create(:article, status: Article::Status::PUBLISHED)
      expect(article.date_published.to_date).to eq(Time.current.to_date)
    end

    it 'should set date_published on update and publishing article' do
      article = create(:article, status: Article::Status::SUBMITTED_FOR_APPROVAL)
      article.update_attributes(status: Article::Status::PUBLISHED)
      expect(article.date_published.to_date).to eq(Time.current.to_date)
      expect(article.date_published).to be_within(1.minute).of(Time.current)
    end
  end

  context 'cover_image' do
    it 'should return the cover_image that was not used for preview' do
      article = create(:article)
      cover1 = create(:cover_image, preview_image: true, article: article)
      cover2 = create(:cover_image, preview_image: false, article: article)
      cover3 = create(:cover_image, preview_image: false)
      cover4 = create(:cover_image, preview_image: true, article: article)

      expect(article.cover_image).to eq(cover2)
    end
  end

  context 'cover_image_url' do
    before do
      allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
    end

    it 'should return url of cover_photo of cover_image' do
      article = create(:article)
      cover_photo = Rack::Test::UploadedFile.new('spec/factories/test.png', 'image/png')
      cover = create(:cover_image, preview_image: false, article: article, cover_photo: cover_photo)

      expect(article.cover_image_url.split('/')).to include(/test.png*/)
      expect(article.cover_image_url.split('/')).to include('original')
      expect([article.cover_image_url]).to include(/^http:\/\/s3.amazonaws.com\/cover_image_test\/cover_images\/cover_photos/)
    end

    it 'should return thumb url if required' do
      article = create(:article)
      cover_photo = Rack::Test::UploadedFile.new('spec/factories/test.png', 'image/png')
      cover = create(:cover_image, preview_image: false, article: article, cover_photo: cover_photo)

      article_cover_image_url = article.cover_image_url(:thumb)
      expect(article_cover_image_url.split('/')).to include(/test.png*/)
      expect(article_cover_image_url.split('/')).to include('thumb')
      expect([article_cover_image_url]).to include(/^http:\/\/s3.amazonaws.com\/cover_image_test\/cover_images\/cover_photos/)
    end

    it 'should return medium url if required' do
      article = create(:article)
      cover_photo = Rack::Test::UploadedFile.new('spec/factories/test.png', 'image/png')
      cover = create(:cover_image, preview_image: false, article: article, cover_photo: cover_photo)

      article_cover_image_url = article.cover_image_url(:medium)
      expect(article_cover_image_url.split('/')).to include(/test.png*/)
      expect(article_cover_image_url.split('/')).to include('medium')
      expect([article_cover_image_url]).to include(/^http:\/\/s3.amazonaws.com\/cover_image_test\/cover_images\/cover_photos/)
    end

    it 'should return default url if no cover_image is present' do
      article = create(:article)
      article_cover_image_url = article.cover_image_url(:medium)
      expect(article_cover_image_url).to eq('z_medium.png')
    end
  end

  context 'owners' do
    it 'should return both system_users and users' do
      user1 = create(:user)
      user2 = create(:user)
      author = create(:author)
      article = create(:article)
      ArticleOwner.create(article: article, owner: user1)
      ArticleOwner.create(article: article, owner: user2)
      ArticleOwner.create(article: article, owner: author)
      ArticleOwner.create(article: create(:article), owner: author)

      expect(article.owners.collect(&:id)).to match_array([user1.id, user2.id, author.id])
    end
  end

  context 'principal_author' do
    it 'should return the owner' do
      user = create(:user)
      article = create(:article)
      ArticleOwner.create(article: article, owner: user)

      expect(article.principal_author.id).to eq(user.id)
    end
  end
end
