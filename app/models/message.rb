class Message < ApplicationRecord
  belongs_to :user
  belongs_to :protector
  belongs_to :room
end
