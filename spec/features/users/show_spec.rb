require "rails_helper"

RSpec.describe "dashboard_path", type: :feature do
  describe "on a user dashboard" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }

    before(:each) do 
      @party1 = Party.create!(duration: 100, party_date: "08/02/23" , party_time: "12:00", movie_id: 500)
      @party2 = Party.create!(duration: 120, party_date: "08/03/23", party_time: "8:00", movie_id: 400)
      @u1p1 = UserParty.create!(user_id: user.id, party_id: @party1.id, is_host: true)
      @u2p1 = UserParty.create!(user_id: user2.id, party_id: @party1.id, is_host: false)
    end

    it "should render only the user's name", :vcr do
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_on "Submit"

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("#{user.name}'s Dashboard")
      expect(page).to_not have_content("#{user2.name}'s Dashboard")
    end

    it "routes me to the discover movies dashboard", :vcr do
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_on "Submit"

      click_button "Discover Movies"
      expect(current_path).to eq(discover_path)
    end

    xit "should render the parties the user is invited to", :vcr do 
      within ".invited_to_parties" do
        expect(page).to have_content("Reservoir Dogs")
        expect(page).to have_content(@party1.party_date)
        expect(page).to have_content(@party1.party_time)
        expect(page).to have_content("Invited")
        expect(page).to have_content("Hosted by: #{@user_1.name}")
        expect(page).to have_content("#{@user_2.name}")
      end

      # within ".hosting_parties" do
      #   expect(page).to have_content("Things to Do in Denver When You're Dead")
      #   expect(page).to have_content(@party2.party_date)
      #   expect(page).to have_content(@party2.party_time)
      #   expect(page).to have_content("Invited")
      #   expect(page).to have_content("Hosted by: #{@user_2.name}")
      #   expect(page).to have_content("#{@user_2.name}")
      # end
    end
  end
end
