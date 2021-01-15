class Notification < ApplicationRecord
  belongs_to :dog,               optional: true
  belongs_to :message,           optional: true
  belongs_to :room,              optional: true
  belongs_to :visitor_protector, class_name: 'Protector', foreign_key: 'visitor_protector_id', optional: true
  belongs_to :visited_protector, class_name: 'Protector', foreign_key: 'visited_protector_id', optional: true
  belongs_to :visitor_user,      class_name: 'User',      foreign_key: 'visitor_user_id',      optional: true
  belongs_to :visited_user,      class_name: 'User',      foreign_key: 'visited_user_id',      optional: true

  scope :paginate, -> (p) { page(p[:page]) }
  scope :sorted, -> { order('id DESC') }
end
