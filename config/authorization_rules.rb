authorization do
  role :guest do
    has_permission_on :home, to: [:index]
    has_permission_on :articles, to: [:index, :search]
    has_permission_on :articles, to: [:show] do
      if_attribute status: is { Article::Status::PUBLISHED }
    end
    has_permission_on :newsletters, to: :subscribe
    has_permission_on :users, to: [:failure]
  end

  role :registered_user do
    includes :guest
    has_permission_on :users, to: [:change_email_form, :change_email, :failure] do
      if_attribute id: is { user.id }
    end

    has_permission_on :articles, to: [:new, :create, :index]

    has_permission_on :articles, to: [:destroy, :edit, :update] do
      if_attribute creator_id: is { user.id }, status: is { Article::Status::DRAFT  }
    end
    has_permission_on :articles, to: [:destroy, :edit, :update] do
      if_attribute creator_id: is { user.id }, status: is { Article::Status::PREVIEW  }
    end

    has_permission_on :articles, to: [:show] do
      if_attribute creator_id: is { user.id }
    end

    has_permission_on :tags, to: [:index]
  end

  role :editor do
    includes :registered_user
    has_permission_on :newsletters, to: :new do
      if_attribute has_no_draft?: is { true }
    end
    has_permission_on :newsletters, to: [:create, :update, :show, :destroy, :index, :preview]
    has_permission_on :newsletters, to: :edit do
      if_attribute status: is { Newsletter::Status::DRAFT }
    end
    has_permission_on :articles, to: [:approve_form, :approve] do
      if_attribute status: is { Article::Status::SUBMITTED_FOR_APPROVAL }
    end

    has_permission_on :articles, to: [:show] do
      if_attribute status: is_not { Article::Status::DRAFT }
    end

    has_permission_on :articles, to: [:home_page_order_update]

    has_permission_on :authors, to: [:new, :create, :edit, :update, :show, :destroy, :index]
  end

  role :administrator do
    includes :editor
    has_permission_on :users, to: [:edit, :update, :destroy, :index]
  end
end
