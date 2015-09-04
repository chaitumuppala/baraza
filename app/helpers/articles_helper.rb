module ArticlesHelper
  def cover_image_url_for(article)
    url_to_image(article.cover_image_url)
  end

  def truncate_summary(summary)
    truncate(summary, length: 153)
  end

  def author_options(article)
    selected_value = "User:#{current_user.id}"
    owner_option = [[current_user.full_name, selected_value]]
    if article.owners.present?
      owner = article.owners.first
      selected_value = "#{owner.is_a?(Author) ? 'Author' : 'User'}:#{owner.id}"
      owner_option << [owner.full_name, selected_value]
    end
    select_options = (Author.all.collect { |owner| [owner.full_name, "Author:#{owner.id}"]} + owner_option).uniq.compact
    [select_options, selected_value]
  end
end
