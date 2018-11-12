# == Schema Information
#
# Table name: genres
#
#  id           :integer          not null, primary key
#  name         :string
#  movies_count :integer          default 0
#  created_at   :datetime
#  updated_at   :datetime
#

class Genre < ApplicationRecord
  has_many :movies
end
