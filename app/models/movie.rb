# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  released_at :datetime
#  avatar      :string
#  genre_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Movie < ApplicationRecord
  belongs_to :genre, counter_cache: true

  delegate :plot, :rating, :poster_url, to: :api, allow_nil: true

  private
 
  def api
    return nil if id.nil?

    @@api_cache ||= {}
    @@api_cache[id] ||= PairguruApi::Movie.find(id)
  rescue ActiveResource::ClientError
    # ClientError is inherited by all error statuses like 404, 500 etc.
    # In case we want to monitor issues with this API, we can
    #   add here reporting to our bug tracking tool.
    nil
  end
end
