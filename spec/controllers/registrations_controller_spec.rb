require 'rails_helper'

describe RegistrationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  it "should return json on error" do
    post "create", user: {first_name: "", last_name: "", email: "", password: "Password1!",
                          password_confirmation: "Password1!", year_of_birth: "", country: "", gender: ""}
    expect(response.code).to eq("422")
    expect(response.body).to eq("Email can't be blank, First name can't be blank, and Last name can't be blank")
  end

  it "should permit :first_name, :last_name, :year_of_birth, :country, :gender" do
    emailid = "email@email.com"
    first_name = "fname"
    last_name = "lname"
    year_of_birth = "2000"
    country = "India"
    gender = "F"
    post "create", user: {first_name: first_name, last_name: last_name, email: emailid, password: "Password1!",
                            password_confirmation: "Password1!", year_of_birth: year_of_birth, country: country, gender: gender}, commit: "Register"

    user = User.find_by(email: emailid)
    expect(user.first_name).to eq(first_name)
    expect(user.last_name).to eq(last_name)
    expect(user.year_of_birth).to eq(year_of_birth.to_i)
    expect(user.country).to eq(country)
    expect(user.gender).to eq(gender)
  end
end