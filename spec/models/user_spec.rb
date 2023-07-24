require 'rails_helper'

RSpec.describe User, type: :model do
  describe "relationships" do
    it { should have_many :user_parties }
    it { should have_many(:parties).through(:user_parties) }
  end

  describe "validations" do
    # require 'pry'; binding.pry
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:password)}
    it { should validate_presence_of(:password_confirmation)}
    it { should have_secure_password}
  end

  describe ".other_users" do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
  
      @party1 = create(:party, movie_id: 2)
      @party2 = create(:party, movie_id: 3)
      
      @user_party1 = UserParty.create!(user_id: @user1.id, party_id: @party1.id, is_host: false)
      @user_party2 = UserParty.create!(user_id: @user2.id, party_id: @party1.id, is_host: true)
      @user_party3 = UserParty.create!(user_id: @user1.id, party_id: @party2.id, is_host: true)
      @user_party4 = UserParty.create!(user_id: @user3.id, party_id: @party2.id, is_host: false)
    end

    it "returns an array of all users except the specified user" do
      expect(User.other_users(@user1)).to eq([@user2, @user3])
    end
  end
  
  describe "#invitations" do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }

    before(:each) do 
      @party1 = Party.create!(duration: 100, party_date: "08/02/23" , party_time: "12:00", movie_id: 500)
      @party2 = Party.create!(duration: 120, party_date: "08/03/23", party_time: "8:00", movie_id: 400)
      @u1p1 = UserParty.create!(user_id: user.id, party_id: @party1.id, is_host: true)
      @u2p1 = UserParty.create!(user_id: user2.id, party_id: @party1.id, is_host: false)
    end
    
    xit "returns the parties the user is invited to" do 
      expect(user.invitations).to eq([])
      require 'pry'; binding.pry
      expect(user2.invitations.to_a).to eq([@party1])

      @u1p2 = UserParty.create!(user_id: user.id, party_id: @party1.id, is_host: false)
      @u2p2 = UserParty.create!(user_id: user2.id, party_id: @party1.id, is_host: true)

      expect(user.invitations).to eq([@party2])
      expect(user2.invitations).to eq([@party1])
    end

    xit "returns the parties the user is hosting" do 
      expect(user2.parties_hosting).to eq([])
      expect(user.parties_hosting).to eq([@party1])

      @u1p2 = UserParty.create!(user_id: user.id, party_id: @party1.id, is_host: false)
      @u2p2 = UserParty.create!(user_id: user2.id, party_id: @party1.id, is_host: true)

      expect(user2.parties_hosting).to eq([@party2])
      expect(user.parties_hosting).to eq([@party1])
    end
  end
end
