require "rails_helper"

RSpec.describe MovieFacade do
  describe "#find_movies", :vcr do
    it "can find top rated movies" do
      top_movies = MovieFacade.new.find_movies

      expect(top_movies).to be_an(Array)

      top_movies.each do |top_movie|
        expect(top_movie).to be_a(Movie)
        expect(top_movie.title).to be_a(String)
        expect(top_movie.id).to be_an(Integer)
        expect(top_movie.vote_average).to be_a(Float)
      end
    end

    it "can search movies by keyword" do
      movies_by_keyword = MovieFacade.new("Princess").find_movies

      expect(movies_by_keyword).to be_an(Array)

      movies_by_keyword.each do |keyword_movie|
        expect(keyword_movie).to be_a(Movie)
      end
    end
  end

  describe "#show_movie_details", :vcr do
    it "create a movie object with attributes" do
      movie_fac = MovieFacade.new(238)
      movie = movie_fac.show_movie_details

      expect(movie).to be_a(Movie)
      expect(movie.title).to eq("The Godfather")
      expect(movie.vote_average).to eq(8.711)
      expect(movie.runtime).to eq(175)
      expect(movie.overview).to be_a(String)
    end
  end
end
