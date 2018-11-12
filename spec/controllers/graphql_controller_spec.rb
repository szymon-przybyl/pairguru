require 'rails_helper'

describe GraphqlController do
  def execute(query)
    post :execute, params: { query: query }
  end

  let!(:genre) { Genre.create name: 'Comedy' }
  let!(:movie) { Movie.create title: 'Test', genre: genre }

  it 'returns movie details on movie query' do
    execute "{ movie(id: #{movie.id}) { id title } }"
    expect(JSON.parse(response.body)['data']['movie']).to eq(
      'id' => movie.id.to_s,
      'title' => 'Test'
    )
  end

  it 'returns movie and genre details on movie query' do
    execute "{ movie(id: #{movie.id}) { id title genre { id name moviesCount } } }"
    expect(JSON.parse(response.body)['data']['movie']).to eq(
      'id' => movie.id.to_s,
      'title' => 'Test',
      'genre' => {
        'id' => genre.id.to_s,
        'name' => 'Comedy',
        'moviesCount' => 1
      }
    )
  end

  context 'with another movie' do
    let!(:movie2) { Movie.create title: 'Test2', genre: genre }

    it 'returns movies details on movies query' do
      execute '{ movies { id title } }'
      expect(JSON.parse(response.body)['data']['movies']).to include(
        {
          'id' => movie.id.to_s,
          'title' => 'Test'
        },
        {
          'id' => movie2.id.to_s,
          'title' => 'Test2'
        }
      )
    end

    it 'returns movies and genres details on movies query' do
      execute '{ movies { id title genre { id name moviesCount } } }'
      expect(JSON.parse(response.body)['data']['movies']).to include(
        {
          'id' => movie.id.to_s,
          'title' => 'Test',
          'genre' => {
            'id' => genre.id.to_s,
            'name' => 'Comedy',
            'moviesCount' => 2
          }
        },
        {
          'id' => movie2.id.to_s,
          'title' => 'Test2',
          'genre' => {
            'id' => genre.id.to_s,
            'name' => 'Comedy',
            'moviesCount' => 2
          }
        }
      )
    end
  end
end
