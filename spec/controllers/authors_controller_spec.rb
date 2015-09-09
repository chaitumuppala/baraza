# require 'rails_helper'
#
# RSpec.describe AuthorsController, type: :controller do
#   it "should allow render of new", admin_sign_in: true do
#     get :new
#     expect(response).to render_template(:new)
#   end
#
#   it "should not allow render of new for normal users" do
#     get :new
#     expect(response).to redirect_to(new_user_session_path)
#   end
#
#   it "should not allow render of new for normal users", sign_in: true do
#     get :new
#     expect(response).to redirect_to(root_path)
#   end
# end
