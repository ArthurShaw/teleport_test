class User < ApplicationRecord
  require 'securerandom'
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  
  has_many :posts, dependent: :destroy
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  
  validates :first_name, :last_name, :login, presence: true

  scope :unfriended, ->(user) do
    joins('LEFT JOIN friendships ON friendships.friend_id = users.id')
      .where('friendships.id is NULL OR friendships.friend_id NOT IN (?)',
             user.friends.ids.present? ? user.friends.ids : 0)
      .where.not(id: user.id)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.name.split(' ').first
      user.last_name = auth.info.name.split(' ').last
      user.login = SecureRandom.hex(8)
    end
  end
  
end
