module Types
  class Genre < GraphQL::Schema::Object
    field :id, ID, null: false
    field :name, String, null: true
    field :movies_count, Int, null: false
  end
end
