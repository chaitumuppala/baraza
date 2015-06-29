ActiveAdmin.register Newsletter do
  permit_params :name, article_ids: []
  actions :edit, :update, :index, :create, :show

  index do
    column :name
    column :status
    actions
  end

  form do |f|
    render "admin/newsletters/form"
  end
end

