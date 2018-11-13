# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  movie_id    :integer
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :content, presence: true
  validate :one_comment_per_user

  private

  def one_comment_per_user
    return unless movie && user
    if user.commented_movie?(movie)
      errors.add(:movie, 'was already commented by you')
    end
  end
end
