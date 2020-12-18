class Message < ApplicationRecord
  belongs_to :user,      optional: true
  belongs_to :protector, optional: true
  belongs_to :room

  validates :room_id,      presence: true
  validates :content,      presence: true,
                           length: { maximum: 100 }
end
