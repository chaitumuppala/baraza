# == Schema Information
#
# Table name: articles
#
#  id                     :integer          not null, primary key
#  title                  :string(255)      not null
#  content                :text             not null
#  creator_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  top_story              :boolean
#  newsletter_id          :integer
#  position_in_newsletter :integer
#  status                 :string(255)      default("draft")
#  author_content         :text
#  summary                :text             not null
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

describe Article, type: :model do

  it "has a valid factory" do
    expect(build :article).to be_valid
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:summary) }

  xit "can have one or more tags"
  xit "does not duplicate tags"
  xit "can be found by tag"
  xit "can be assigned to a category"
  xit "can be found by category"
  xit "updates the published date when published"

  xit 'should sort results by date_published'

  # TODO: Vijay: Uncomment and fix
  # it { should validate_uniqueness_of(:home_page_order).case_insensitive }

  # context 'cover_image' do
  #   it 'should return the cover_image that was not used for preview' do
  #     article = create(:article)
  #     create(:cover_image, preview_image: true, article: article)
  #     cover2 = create(:cover_image, preview_image: false, article: article)
  #     create(:cover_image, preview_image: false)
  #     create(:cover_image, preview_image: true, article: article)
  #
  #     expect(article.cover_image).to eq(cover2)
  #   end
  # end

  # context 'cover_image_url' do
  #   before do
  #     allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
  #   end
  #
  #   it 'should return url of cover_photo of cover_image' do
  #     article = create(:article)
  #     cover_photo = Rack::Test::UploadedFile.new('spec/factories/test.png', 'image/png')
  #     create(:cover_image, preview_image: false, article: article, cover_photo: cover_photo)
  #
  #     expect(article.cover_image_url.split('/')).to include(/test.png*/)
  #     expect(article.cover_image_url.split('/')).to include('original')
  #     expect([article.cover_image_url]).to include(/^http:\/\/s3.amazonaws.com\/cover_image_test\/cover_images\/cover_photos/)
  #   end
  #
  #   it 'should return thumb url if required' do
  #     article = create(:article)
  #     cover_photo = Rack::Test::UploadedFile.new('spec/factories/test.png', 'image/png')
  #     create(:cover_image, preview_image: false, article: article, cover_photo: cover_photo)
  #
  #     article_cover_image_url = article.cover_image_url(:thumb)
  #     expect(article_cover_image_url.split('/')).to include(/test.png*/)
  #     expect(article_cover_image_url.split('/')).to include('thumb')
  #     expect([article_cover_image_url]).to include(/^http:\/\/s3.amazonaws.com\/cover_image_test\/cover_images\/cover_photos/)
  #   end

    # it 'should return medium url if required' do
    #   article = create(:article)
    #   cover_photo = Rack::Test::UploadedFile.new('spec/factories/test.png', 'image/png')
    #   create(:cover_image, preview_image: false, article: article, cover_photo: cover_photo)
    #
    #   article_cover_image_url = article.cover_image_url(:medium)
    #   expect(article_cover_image_url.split('/')).to include(/test.png*/)
    #   expect(article_cover_image_url.split('/')).to include('medium')
    #   expect([article_cover_image_url]).to include(/^http:\/\/s3.amazonaws.com\/cover_image_test\/cover_images\/cover_photos/)
    # end
    #
    # it 'should return default url if no cover_image is present' do
    #   article = create(:article)
    #   article_cover_image_url = article.cover_image_url(:medium)
    #   expect(article_cover_image_url).to eq('z_medium.png')
    # end
  # end

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
