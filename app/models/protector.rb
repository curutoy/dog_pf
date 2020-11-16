class Protector < ApplicationRecord
  has_one_attached :image
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name,    presence: true,
                      length: { maximum: 20 }
  validates :email,   presence: true,
                      length: { maximum: 60 }
  validates :address, presence: true
  validates :profile, length: { maximum: 200 }
  validates :image,   content_type: {
                        in: %w(image/jpeg image/png),
                        message: "jpgまたはpngの画像を添付してください",
                      },
                      size: {
                        less_than: 5.megabytes,
                        message: "5MB以下のファイルを選んでください",
                      }
end
