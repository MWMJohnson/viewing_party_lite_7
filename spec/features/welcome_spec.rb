require "rails_helper"

RSpec.describe "/", type: :feature do
  describe "when an unregistered or logged out user visits the root path" do
    it "should be the landing page with the title of the app" do
      visit root_path
      expect(page).to have_content("Viewing Party")
    end

    it "I see a link to take me back to the welcome page" do
      visit root_path

      click_link "Home"

      expect(current_path).to eq(root_path)
    end

    it "displays a button to create a new user" do
      visit root_path

      expect(page).to have_button("Create a New User")
    end

    it "displays a link to log in for already registered users" do
      visit root_path

      expect(page).to have_link("Log In")
    end

    it "it does not display existing users" do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      user4 = User.create(name: "Testy Tim", email: "test@email.com", password: "test", password_confirmation: "test")

      visit root_path

      expect(current_path).to eq(root_path)
      within(".users") do
        expect(page).to_not have_content("Existing Users")
        expect(page).to_not have_content(user1.email)
        expect(page).to_not have_content(user2.email)
        expect(page).to_not have_content(user3.email)
      end
    end

    it "can log in with valid credentials" do
      user = User.create(name: "Testy Tim", email: "test@email.com", password: "test", password_confirmation: "test")
  
      visit root_path
  
      click_on "Log In"
  
      expect(current_path).to eq(login_path)
  
      fill_in :email, with: user.email
      fill_in :password, with: user.password
  
      click_on "Submit"
  
      expect(current_path).to eq(dashboard_path)
    end

    it "cannot log in with invalid email" do
      user = User.create(name: "Testy Tim", email: "test@email.com", password: "test", password_confirmation: "test")
  
      visit root_path
  
      click_on "Log In"
  
      expect(current_path).to eq(login_path)
  
      fill_in :email, with: "test_TYPO_@email.com"
      fill_in :password, with: user.password
  
      click_on "Submit"
  
      expect(current_path).to eq(login_path)
      expect(page).to have_content("Credentials invalid")
    end

    it "cannot log in with invalid password" do
      user = User.create(name: "Testy Tim", email: "test@email.com", password: "test", password_confirmation: "test")
  
      visit root_path
  
      click_on "Log In"
  
      expect(current_path).to eq(login_path)
  
      fill_in :email, with: user.email
      fill_in :password, with: "wrong_password"
  
      click_on "Submit"
  
      expect(current_path).to eq(login_path)
      expect(page).to have_content("Credentials invalid")
    end

    it "rejects access to the dashboard page if the user is not logged in" do 
      visit root_path
      visit dashboard_path
      expect(current_path).to eq(root_path)
      expect(page).to have_content("You must be logged in to access your dashboard")
    end
  end

  describe "when a registered user visits root path" do
    it "should be the landing page with the title of the app" do
      visit root_path
      expect(page).to have_content("Viewing Party")
    end

    it "I see a link to take me back to the welcome page" do
      visit root_path

      click_link "Home"

      expect(current_path).to eq(root_path)
    end

    it "does not display a button to create a new user" do
      user = User.create(name: "Testy Tim", email: "test@email.com", password: "test", password_confirmation: "test")
      
      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: user.password
  
      click_on "Submit"
      click_on "Home"

      expect(page).to_not have_button("Create a New User")
    end

    it "does not display a link to log in" do
      user = User.create(name: "Testy Tim", email: "test@email.com", password: "test", password_confirmation: "test")
      
      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: user.password
  
      click_on "Submit"
      click_on "Home"

      expect(page).to_not have_link("Log In")
    end

    it "has a list of Existing Users which links to the users dashboard" do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      user4 = User.create(name: "Testy Tim", email: "test@email.com", password: "test", password_confirmation: "test")

      visit root_path
      click_on "Log In"
  
      fill_in :email, with: user4.email
      fill_in :password, with: user4.password
      click_on "Submit"
      click_on "Home"

      expect(current_path).to eq(root_path)
      within(".users") do
        expect(page).to have_content("Existing Users")
        expect(page).to have_content(user1.email)
        expect(page).to have_content(user2.email)
        expect(page).to have_content(user3.email)
      end
    end

    it "as a logged in user I am able to log out" do
      user = User.create(name: "Testy Tim", email: "test@email.com", password: "test", password_confirmation: "test")
  
      visit root_path
  
      click_on "Log In"
  
      expect(current_path).to eq(login_path)
  
      fill_in :email, with: user.email
      fill_in :password, with: user.password
  
      click_on "Submit"
  
      expect(current_path).to eq(dashboard_path)
      click_on "Home"
      expect(current_path).to eq(root_path)
      expect(page).to_not have_link("Log In")
      expect(page).to_not have_button("Create a New User")
      
      click_link("Log Out")

      expect(current_path).to eq(root_path)

      expect(page).to_not have_link("Log Out")

      expect(page).to have_link("Log In")
      expect(page).to have_button("Create a New User")
    end

    it "allows access to the dashboard page if the user is logged in" do 
      user = create(:user)
      
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_on "Submit"
      click_on "Home"
      visit dashboard_path
      expect(current_path).to eq(dashboard_path)
      # expect(page).to have_content("You must be logged in to access your dashboard")
    end
  end
end
