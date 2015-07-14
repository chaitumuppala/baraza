authorization do
  role :guest do
    has_permission_on :home, to: [:index]
    has_permission_on :articles, to: [ :index, :search ]
    has_permission_on :articles, to: [ :show ] do
      if_attribute status: is {Article::Status::PUBLISHED}
    end
    has_permission_on :newsletters, to: :subscribe
  end

  role :registered_user do
    includes :guest
    has_permission_on :users, to: [:change_email_form, :change_email] do
      if_attribute :id => is { user.id }
    end

    has_permission_on :articles, to: [:new, :create, :index ]

    has_permission_on :articles, to: [:edit, :update] do
      if_attribute :user_id => is { user.id }, status: is {Article::Status::DRAFT}
    end

    has_permission_on :articles, to: [ :show ] do
      if_attribute :user_id => is { user.id }
    end

    has_permission_on :tags, to: [:index ]
  end

  role :editor do
    includes :registered_user

    has_permission_on :articles, to: [:approve_form, :approve] do
      if_attribute status: is {Article::Status::SUBMITTED_FOR_APPROVAL}
    end

    has_permission_on :articles, to: [ :show ] do
      if_attribute status: is_not {Article::Status::DRAFT}
    end
  end

  role :administrator do
    includes :editor
    has_permission_on :users, to: [:edit, :update, :destroy, :index]
    has_permission_on :newsletters, to: [:new, :create, :update, :show, :destroy, :index, :preview]
    has_permission_on :newsletters, to: :edit do
      if_attribute :status => is {Newsletter::Status::DRAFT}
    end
    has_permission_on :articles, to: [ :home_page_order, :home_page_order_update ]
  end
end
