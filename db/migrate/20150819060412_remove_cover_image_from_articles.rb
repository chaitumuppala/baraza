class RemoveCoverImageFromArticles < ActiveRecord::Migration
  def up
    # Article.all.each do |article|
      # CoverImage.create(cover_photo_file_size: article.cover_image_file_size,
      #                   cover_photo_content_type: article.cover_image_content_type,
      #                   cover_photo_file_name: article.cover_image_file_name,
      #                   cover_photo_updated_at: Date.today,
      #                   article_id: article.id)
    # end
    remove_attachment :articles, :cover_image
  end

  def down
    add_attachment :articles, :cover_image
    # CoverImage.all.each do |ci|
    #   article = Article.find(ci.article_id)
    #   article.update_attributes(cover_image_file_size: ci.cover_photo_file_size,
    #                             cover_image_content_type: ci.cover_photo_content_type,
    #                             cover_image_file_name: ci.cover_photo_file_name,
    #                             cover_image_updated_at: Date.today)
    # end
  end
end
