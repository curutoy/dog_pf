class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :protector
  belongs_to :room

  validates :user_id,      presence: true
  validates :protector_id, presence: true, uniqueness: { scope: :user_id }
  validates :room_id,      presence: true
end
