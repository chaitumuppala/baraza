require 'rails_helper'

RSpec.describe ArticlesHelper do
  context 'cover_image_url_for' do
    it 'should set the cover_image default image url if no image is provided' do
      article = create(:article)
      expect(helper.cover_image_url_for(article)).to eq('http://test.host/assets/z_original.png')
    end

    it 'should set the actual cover_image url, if present' do
      article = double(:article, cover_image_url: 'http://s3_url/x.png')
      expect(helper.cover_image_url_for(article)).to eq('http://s3_url/x.png')
    end
  end

  context 'truncate_summary' do
    it 'should reduce the text to 150 characters' do
      article = double(:article, summary: ('*' * 75) + ' ' + ('$' * 80))
      expect(helper.truncate_summary(article.summary)).to eq(('*' * 75) + ' ' + ('$' * 74) + '...')
    end
  end

  context 'author_options' do
    before do
      Author.delete_all
      @a1 = create(:author)
      @a2 = create(:author)
    end
    context 'for article creation by admin/editor' do
      it 'should return a list of all authors, the current user and the default select value' do
        admin = create(:administrator)
        article = Article.new
        expect(helper).to receive(:current_user).at_least(:once).and_return(admin)
        actual_select_options, actual_select_value = helper.author_options(article)
        expected_select_options = [[@a1.full_name, "Author:#{@a1.id}"], [@a2.full_name, "Author:#{@a2.id}"], [admin.full_name, "User:#{admin.id}"]]
        expected_select_value = "User:#{admin.id}"
        expect(actual_select_options).to match_array(expected_select_options)
        expect(actual_select_value).to eq(expected_select_value)
      end
    end

    context 'article edition by admin/editor' do
      context 'admin as owner' do
        it 'should return a list of all authors, the current user, the owner and the default select value' do
          admin = create(:administrator)
          article = create(:article)
          article.users << admin
          expect(helper).to receive(:current_user).at_least(:once).and_return(admin)
          actual_select_options, actual_select_value = helper.author_options(article)
          expected_select_options = [[@a1.full_name, "Author:#{@a1.id}"], [@a2.full_name, "Author:#{@a2.id}"], [admin.full_name, "User:#{admin.id}"]]
          expected_select_value = "User:#{admin.id}"
          expect(actual_select_options).to match_array(expected_select_options)
          expect(actual_select_value).to eq(expected_select_value)
        end
      end

      context 'author as owner' do
        it 'should return a list of all authors, the current user, the owner and the default select value' do
          admin = create(:administrator)
          article = create(:article)
          author = create(:author)
          article.system_users << author
          expect(helper).to receive(:current_user).at_least(:once).and_return(admin)
          actual_select_options, actual_select_value = helper.author_options(article)
          expected_select_options = [[@a1.full_name, "Author:#{@a1.id}"], [@a2.full_name, "Author:#{@a2.id}"], [admin.full_name, "User:#{admin.id}"], [author.full_name, "Author:#{author.id}"]]
          expected_select_value = "Author:#{author.id}"
          expect(actual_select_options).to match_array(expected_select_options)
          expect(actual_select_value).to eq(expected_select_value)
        end
      end
    end
  end
end
