# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  has_many :comments

  validates :phone_number, format: { with: /\A[+]?\d+(?>[- .]\d+)*\z/, allow_nil: true }

  scope :top_commenters, -> (period) do
    starting_from = Time.now - period
    select('users.*, COUNT(comments.id) as comments_count')
      .joins(:comments)
      .where('comments.created_at > ?', starting_from)
      .group('users.id')
      .order('comments_count DESC')
  end

  def commented_movie?(movie)
    comments.where(comments: { movie_id: movie.id }).any?
  end
end
