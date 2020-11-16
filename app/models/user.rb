class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  validates :name,          presence: true,
                            length: { maximum: 20 }
  validates :email,         presence: true,
                            length: { maximum: 60 }
  validates :address,       presence: true
  validates :family_people, presence: true
  validates :house,         presence: true
  validates :caretaker,     presence: true
  validates :profile,       length: { maximum: 200 }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
