class Relationship < ApplicationRecord

  belongs_to :protector
  belongs_to :user

  validates :protector_id, presence: true
  validates :user_id, presence: true
end
