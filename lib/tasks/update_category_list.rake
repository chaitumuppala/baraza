namespace :data do
  desc 'Update category list'
  task update_category: :environment do
    cid_to_delete = Category.all[10..12].collect(&:id)
    category_names = ['Features', 'Commentaries', 'Urgent actions', 'Campaigns', 'Reviews', 'Audio-visuals', 'Courses', 'Events', 'Announcements', 'Jobs']
    CategoryNewsletter.where(category_id: cid_to_delete).delete_all
    articles = Article.where(category_id: cid_to_delete)
    articles.update_all(Category.first.id) if articles.present?
    Category.where(id: cid_to_delete).delete_all
    Category.all.each_with_index do |category, index|
      category.name = category_names[index]
      category.save
    end
    p 'Categories updated successfully'
  end
end
