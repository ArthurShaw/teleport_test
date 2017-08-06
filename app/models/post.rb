class Post < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true
  
  scope :friends, ->(user) { where(user: user.friends) }
end
