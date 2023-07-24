require "rails_helper"

RSpec.describe "/register", type: :feature do
  describe "when a user visits register path" do
    it "should be the register page" do
      visit register_path

      expect(page).to have_content("Viewing Party")
      expect(page).to have_content("Register a New User")
    end

    it "displays a form to register a user" do
      visit register_path
      within ".register_form" do
        expect(page).to have_field("Name:")
        expect(page).to have_field("Email:")
        expect(page).to have_field("Password:")
        expect(page).to have_field("Password Confirmation:")
        expect(page).to have_button("Create a New User")
      end
    end

    # Happy Path 1 - User fills in name and unique email, and submits
    it "creates a new user, when successfully completing and submitting the form" do
      visit register_path
    
      within ".register_form" do
        fill_in :user_name, with: "John Doe"
        fill_in :user_email, with: "johndoe@email.com"
        fill_in :user_password, with: "test"
        fill_in :user_password_confirmation, with: "test"
        click_button "Create a New User"
      end
      user = User.all.last
      # require 'pry'; binding.pry
      expect(current_path).to eq(dashboard_path)
    end
    # Sad Path 1 - both Name and Email are required.
    it "does not create a new user, when unsuccessfully completing and submitting the form" do
      visit register_path

      within ".register_form" do
        fill_in :user_email, with: "johndoe@email.com"
        fill_in :user_password, with: "test"
        fill_in :user_password_confirmation, with: "test"
        click_button "Create a New User"
      end

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Name can't be blank")
    end

    # Sad Path 2 - Email must be unique to data table.
    it "should not allow users to register without a unqiue email" do
      user = create(:user)

      visit register_path

      within ".register_form" do
        fill_in :user_name, with: user.name
        fill_in :user_email, with: user.email
        fill_in :user_password, with: "test"
        fill_in :user_password_confirmation, with: "test"
        click_button "Create a New User"
      end

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Email has already been taken")
    end
    # Sad Path 3 - Password and Password Confirmation must both match.
    it "should not allow users to register without a confirmed password" do

      visit register_path

      within ".register_form" do
        fill_in :user_name, with: "Bobby Typo"
        fill_in :user_email, with: "typesfast@email.com"
        fill_in :user_password, with: "test"
        fill_in :user_password_confirmation, with: "tes5"
        click_button "Create a New User"
      end

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Error: Password confirmation doesn't match Password")
    end
  end
end
