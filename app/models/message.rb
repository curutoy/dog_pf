class Message < ApplicationRecord
  belongs_to :user
  belongs_to :protector
  belongs_to :room

  validates :user_id,      presence: true
  validates :protector_id, presence: true
  validates :room_id,      presence: true
  validates :content,      length: { maximum: 100 }
end
