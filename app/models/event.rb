class Event < ApplicationRecord
  belongs_to :protector

  validates :protector_id, presence: true
  validates :due_on,       presence: true
  validates :start_at,     presence: true
  validates :finish_at,    presence: true
  validates :prefecture,   presence: true
  validates :address,      presence: true
  validates :content,      length: { maximum: 200 }
end
