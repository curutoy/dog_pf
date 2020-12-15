class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :dog
  validates :user_id, presence: true
  validates :dog_id,  presence: true, uniqueness: { scope: :user_id }
end
