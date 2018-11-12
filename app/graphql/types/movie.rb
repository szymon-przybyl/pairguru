module Types
  class Movie < GraphQL::Schema::Object
    field :id, ID, null: false
    field :title, String, null: true
    field :genre, Types::Genre, null: true
  end
end
