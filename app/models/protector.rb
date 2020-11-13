class Protector < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name,    presence: true,
                      length: { maximum: 20 }
  validates :email,   presence: true,
                      length: { maximum: 60 }
  validates :address, presence: true
  validates :profile, length: { maximum: 200 }
end
