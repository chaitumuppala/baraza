authorization do
  role :guest do
    has_permission_on :home, to: [:index]
  end

  role :registered_user do
    includes :guest
    has_permission_on :users, to: [:edit, :update] do
      if_attribute :id => is { user.id }
    end

    has_permission_on :articles, to: [:new, :create ]

    has_permission_on :articles, to: [:show, :edit, :update] do
      if_attribute :user_id => is { user.id }
    end

  end

  role :editor do
    includes :registered_user
  end

  role :administrator do
    includes :editor
  end
end
