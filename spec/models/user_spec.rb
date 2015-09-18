# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  uid                    :string(255)
#  provider               :string(255)
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  year_of_birth          :integer
#  country                :string(255)
#  gender                 :string(255)
#  type                   :string(255)
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

describe User, type: :model do

  it "has a valid factory" do
    expect(build :user).to be_valid
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }

    it 'should be inavlid if password length is less than 8 characters' do
      user = build(:user, password: 'Pa1!')
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to eq(['Password is too short (minimum is 8 characters)'])
    end
    
    it 'skips email validation for users associated to providers' do
      expect do
        create(:user, uid: 'uid001', provider: 'facebook', email: nil)
      end.to change { User.count }.by(1)
    end

    it 'should skip email uniqueness validation for users associated to providers' do
      create(:user, uid: 'uid001', provider: 'facebook', email: nil)
      expect do
        create(:user, uid: 'uid002', provider: 'facebook', email: nil)
      end.to change { User.count }.by(1)
    end

    it 'should skip password validation for users associated to providers' do
      expect do
        create(:user, uid: 'uid001', provider: 'facebook', password: nil, password_confirmation: nil)
      end.to change { User.count }.by(1)
    end
  end

  describe "user type" do
    it "is defaulted to registered when not provided" do
      expect(create(:user).type).to eq("RegisteredUser")
    end

    it "is not defaulted when provided" do
      user = create(:user, type: 'Administrator')
      expect(user.type).to eq('Administrator')
    end
  end

  describe "computed attributes" do
    describe '#administrator?' do
      it 'is true for administrator' do
        expect(build(:administrator).administrator?).to eq(true)
      end

      it 'is false for everything else' do
        expect(build(:editor).administrator?).to eq(false)
      end
    end

    describe '#editor?' do
      it 'is true for editor' do
        expect(build(:editor).editor?).to eq(true)
      end
    
      it 'is false for others' do
        expect(build(:administrator).editor?).to eq(false)
      end
    end
  end

#   context 'generate_set_password_token' do
#     it 'should return the token for the user' do
#       user = create(:user)
#       expect(user).to receive(:set_reset_password_token)
#       user.generate_set_password_token
#     end
#   end
#
#   context 'full_name' do
#     it 'should return full_name of user' do
#       expect(build(:user, first_name: 'first', last_name: 'last').full_name).to eq('first last')
#     end
#   end
#
#   context 'articles' do
#     it 'should return articles of owner' do
#       user1 = create(:user)
#       user2 = create(:user)
#       author = create(:author)
#       article1 = create(:article)
#       article2 = create(:article)
#       article3 = create(:article)
#       ArticleOwner.create(article: article1, owner: user1)
#       ArticleOwner.create(article: article2, owner: user1)
#       ArticleOwner.create(article: article1, owner: user2)
#       ArticleOwner.create(article: article3, owner: user2)
#       ArticleOwner.create(article: article1, owner: author)
#
#       expect(user1.articles.collect(&:id)).to match_array([article1.id, article2.id])
#       expect(user2.articles.collect(&:id)).to match_array([article1.id, article3.id])
#       expect(article1.users.collect(&:id)).to match_array([user1.id, user2.id])
#       expect(article1.system_users.collect(&:id)).to match_array([author.id])
#     end
#   end
#
#   context 'proxy_articles' do
#     it 'should return list of articles created on behalf of others' do
#       user = create(:user)
#       article1 = create(:article, creator_id: user.id)
#       article2 = create(:article, creator_id: nil)
#       article3 = create(:article, creator_id: create(:user).id)
#
#       proxy_article_ids = user.proxy_articles.collect(&:id)
#       expect(proxy_article_ids).to eq([article1.id])
#       expect(proxy_article_ids.include?(article2.id)).to eq(false)
#       expect(proxy_article_ids.include?(article3.id)).to eq(false)
#     end
#   end
end
