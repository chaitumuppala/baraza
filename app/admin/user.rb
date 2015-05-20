ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  permit_params :type

  actions :edit, :update, :index

  index do
    column :first_name
    column :last_name
    column :email
    column :type
    actions
  end

  form do |f|
    inputs 'Details' do
      input :type
    end
    actions
  end

  filter :type, as: :select, collection: proc { User::Roles.values }
  filter :country
  filter :provider, as: :select, collection: proc { User.omniauth_providers }
  filter :gender, as: :select, collection: proc { User::GenderCategory.values }
end
