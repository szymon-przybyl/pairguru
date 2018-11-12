module Types
  class QueryType < Types::BaseObject
    field :movie, Types::Movie, null: false do
      argument :id, ID, required: true
    end
    def movie(id:)
      ::Movie.find id
    rescue ActiveRecord::RecordNotFound
      GraphQL::ExecutionError.new("Could not find movie ##{id}")
    end

    field :movies, [Types::Movie], null: false
    def movies
      ::Movie.all
    end
  end
end
