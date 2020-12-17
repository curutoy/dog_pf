class Room < ApplicationRecord
  has_many :entries,  dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 20 }
end
