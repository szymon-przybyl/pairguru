class Comment < ApplicationRecord
  belongs_to :movie
  belongs_to :user

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
