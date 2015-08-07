module ArticlesHelper
  def cover_image_url_for(article)
    url_to_image(article.cover_image.url)
  end

  def truncate_summary(summary)
    truncate(summary, length: 153)
  end
end
