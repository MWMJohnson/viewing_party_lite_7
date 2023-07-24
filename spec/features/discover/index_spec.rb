require "rails_helper"

RSpec.describe "/users/:id/discover, Discover Movies Dashboard", type: :feature do
  let!(:user) { create(:user) }

  before(:each) do 
    visit login_path

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Submit"

    visit discover_path
  end

  describe "on the discover movies dashboard" do
    it "I see a page title of Discover Movies" do
      expect(page).to have_content("Discover Movies")
    end

    it "has a button to discover top rated movies", :vcr do

      click_button("Find Top Rated Movies")

      expect(current_path).to eq(movies_path)
    end

    it "has a form to find movies via keyword", :vcr do
      within ".search-movies" do
        fill_in "Search:", with: "Shrek"
        click_button "Find Movies"
      end

      expect(current_path).to eq(movies_path)
    end
  end
end
