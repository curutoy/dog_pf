class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :dog, optional: true

  validates :dog_id,  presence: true
  validates :content, length: { maximum: 200 }
  validates :image,   content_type: {
                        in: %w(image/jpeg image/png),
                        message: "jpgまたはpngの画像を添付してください",
                      },
                      size: {
                        less_than: 5.megabytes,
                        message: "5MB以下のファイルを選んでください",
                      }

  # imageの登録は必須とする
  validate :image_presence

  def image_presence
    unless image.attached?
      errors.add(:image, 'を添付してください')
    end
  end
end
