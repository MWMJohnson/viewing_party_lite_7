require "rails_helper"

RSpec.describe "/users/:user_id/movies/:movie_id", type: :feature do
  let!(:user) { create(:user) }

  before(:each) do
    visit user_movie_path(user, 238)
  end

  describe "as a user on a movie's show page" do
    it "the page displays info about the movie", :vcr do
      expect(page).to have_css(".title")
      expect(page).to have_css(".vote_avg")
      expect(page).to have_css(".runtime")
      expect(page).to have_css(".genre")
      expect(page).to have_css(".summary")
      expect(page).to have_css(".cast", maximum: 10)
      expect(page).to have_css(".reviews")
      expect(page).to have_content("Runtime: 2hr 55min")
    end

    it "shows the first 10 cast members", :vcr do
      expect(page).to have_content("Cast")
      expect(page).to have_content("Actor: Marlon Brando as Character: Don Vito Corleone")
      expect(page).to have_content("Actor: Al Pacino as Character: Michael Corleone")
      expect(page).to have_content("Actor: James Caan as Character: Sonny Corleone")
      expect(page).to have_content("Actor: Robert Duvall as Character: Tom Hagen")
      expect(page).to have_content("Actor: Richard S. Castellano as Character: Clemenza")
      expect(page).to have_content("Actor: Diane Keaton as Character: Kay Adams")
      expect(page).to have_content("Actor: Talia Shire as Character: Connie Corleone Rizzi")
      expect(page).to have_content("Actor: Gianni Russo as Character: Carlo Rizzi")
      expect(page).to have_content("Actor: Sterling Hayden as Character: Captain McCluskey")
      expect(page).to have_content("Actor: John Marley as Character: Jack Woltz")
    end

    it "displays total number of reviews, each review with author and comments", :vcr do
      within(".reviews") do
        expect(page).to have_content("5 Reviews")
        expect(page).to have_content("futuretv")
        expect(page).to have_content("Suresh Chidurala")
        expect(page).to have_content("Great Movie **Ever**")
      end
    end

    it "has a button to route back to the discover page", :vcr do
      click_button "Discover Page"

      expect(current_path).to eq(user_discover_index_path(user))
    end

    it "has a button to create a viewing party for this movie", :vcr do
      click_button "Create Viewing Party for The Godfather"

      expect(current_path).to eq(new_user_movie_viewing_party_path(user, 238))
    end
  end
end
