require "rails_helper"

describe "Genres requests", type: :request do
  before do
    mocked_movie = PairguruApi::Movie.new(
      plot: 'blah',
      rating: 3,
      poster_url: 'http://someurl/image.jpg'
    )
    allow_any_instance_of(Movie).to receive(:api).and_return(mocked_movie)
  end
  let!(:genres) { create_list(:genre, 5, :with_movies) }

  describe "genre list" do
    it "displays only related movies" do
      visit "/genres/" + genres.sample.id.to_s + "/movies"
      expect(page).to have_selector("table tr", count: 5)
    end
  end
end
