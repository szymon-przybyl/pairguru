class AddMoviesCountToGenres < ActiveRecord::Migration[5.2]
  def change
    add_column :genres, :movies_count, :integer, default: 0
    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE genres
           SET movies_count = (SELECT count(1)
                               FROM movies
                               WHERE movies.genre_id = genres.id)
    SQL
  end
end
