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
  permit_params :type, :first_name, :last_name, :email, :password

  actions :edit, :update, :index, :new, :create

  index do
    column :first_name
    column :last_name
    column :email
    column :type
    actions
  end

  form do |f|
    inputs 'Details' do
      if f.object.new_record?
        input :first_name
        input :last_name
        input :email
        input :password
        input :type, as: :select, collection: [User::Roles::ADMINISTRATOR]
      else
        input :type, as: :select, collection: User::Roles.values
      end
    end
    actions
  end

  filter :type, as: :select, collection: proc { User::Roles.values }
  filter :provider, as: :select, collection: proc { User.omniauth_providers }
  filter :gender, as: :select, collection: proc { User::GenderCategory.values }
end
