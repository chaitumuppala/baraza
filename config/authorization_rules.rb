authorization do
  role :guest do
    has_permission_on :home, to: [:index]
  end

  role :registered_user do
    has_permission_on :users, to: [:edit, :update] do
      if_attribute :id => is { user.id }
    end
  end

  role :editor do

  end

  role :admin do

  end
end
