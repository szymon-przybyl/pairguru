require 'rails_helper'

describe 'Comments requests', type: :request do
  let!(:user) { create :user }
  let!(:movie) { create :movie }
  before do
    user.confirm
    sign_in user
    mocked_movie = PairguruApi::Movie.new(
      plot: 'blah',
      rating: 3,
      poster_url: 'http://someurl/image.jpg'
    )
    allow_any_instance_of(Movie).to receive(:api).and_return(mocked_movie)
  end

  describe 'movie comment list' do
    it 'allows to create comment' do
      visit "/movies/#{movie.id}"
      fill_in 'comment_content', with: 'Awesome movie!'
      click_button 'Create Comment'
      expect(page).to have_selector('.comment .content', text: 'Awesome movie!')
      expect(page).to have_content('You already commented this movie.')
      expect(page).to_not have_selector('#comment_content')
    end

    it 'allows to remove comment' do
      create :comment, movie: movie, user: user, content: 'Nice'
      visit "/movies/#{movie.id}"
      click_link "Remove comment"
      expect(page).to_not have_selector('.comment .content', text: 'Nice')
    end
  end
end
