require "rails_helper"

RSpec.describe MovieFacade do
  describe "#find_movies", :vcr do
    it "can find top rated movies" do
      user = create(:user)
      params = {user_id: user.id}
      top_movies = MovieFacade.new(params).movies

      expect(top_movies).to be_an(Array)

      top_movies.each do |top_movie|
        expect(top_movie).to be_a(Movie)
        expect(top_movie.title).to be_a(String)
        expect(top_movie.id).to be_an(Integer)
        expect(top_movie.vote_average).to be_a(Float)
      end
    end

    it "can search movies by keyword" do
      user = create(:user)
      params = {keyword: "Princess"}
      movies_by_keyword = MovieFacade.new(params).movies

      expect(movies_by_keyword).to be_an(Array)

      movies_by_keyword.each do |keyword_movie|
        expect(keyword_movie).to be_a(Movie)
      end
    end
  end

  describe "#show_movie_details", :vcr do
    it "create a movie object with attributes" do
      user = create(:user)
      params = {id: 238}
      movie = MovieFacade.new(params).movie

      expect(movie).to be_a(Movie)
      expect(movie.title).to eq("The Godfather")
      expect(movie.vote_average).to eq(8.711)
      expect(movie.runtime).to eq(175)
      expect(movie.overview).to be_a(String)
    end
  end
end
