require "rails_helper"

describe Movie do
  it { expect(subject.plot).to be_nil }
  it { expect(subject.rating).to be_nil }
  it { expect(subject.poster_url).to be_nil }

  context 'with external movie' do
    before do
      api_movie = {
        plot: 'blah',
        rating: 4,
        poster_url: 'http://someurl/image.jpg'
      }
      stub_request(:get, 'http://pairguru-api/movies/1.json')
        .to_return(status: 200, body: api_movie.to_json)
    end
    let(:movie) { described_class.new(id: 1) }

    it { expect(movie.plot).to eq 'blah' }
    it { expect(movie.rating).to eq 4 }
    it { expect(movie.poster_url).to eq 'http://someurl/image.jpg' }

    context 'with another external movie' do
      before do
        api_movie = {
          plot: 'blah blah',
          rating: 3,
          poster_url: 'http://someurl/image2.jpg'
        }
        stub_request(:get, 'http://pairguru-api/movies/2.json')
          .to_return(status: 200, body: api_movie.to_json)
      end

      it 'updates cached values after ID is changed' do
        expect(movie.plot).to eq 'blah'
        movie.id = 2
        expect(movie.plot).to eq 'blah blah'
      end
    end
  end

  context 'with 404 response from API' do
    before do
      stub_request(:get, 'http://pairguru-api/movies/3.json')
        .to_return(status: 404, body: '{}')
    end
    let(:movie) { described_class.new(id: 3) }

    it { expect(movie.plot).to be_nil }
    it { expect(movie.rating).to be_nil }
    it { expect(movie.poster_url).to be_nil }
  end
end
