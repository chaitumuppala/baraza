require 'rails_helper'

describe "user route" do
  it "should route to users_controller create" do
    { :post => "/admin_users"}.should route_to :controller => "users", :action => "create"
  end
end
