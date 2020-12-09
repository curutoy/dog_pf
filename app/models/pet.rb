class Pet < ApplicationRecord
  has_one_attached :image

  belongs_to :user

  validates :user_id,   presence: true
  validates :age,       presence: true
  validates :gender,    presence: true
  validates :character, length: { max_num: 50 }
  validates :image, content_type: {
    in: %w(image/jpeg image/png),
    message: "jpgまたはpngの画像を添付してください",
  },
                    size: {
                      less_than: 5.megabytes,
                      message: "5MB以下のファイルを選んでください",
                    }

  enum age: {
    不明: 1, １歳未満: 2, １歳: 3, ２歳: 4, ３歳: 5, ４歳: 6,
    ５歳: 7, ６歳: 8, ７歳: 9, ８歳: 10, ９歳: 11, １０歳: 12,
    １１歳: 13, １２歳: 14, １３歳: 15, １４歳: 16, １５歳以上: 17,
  }

  enum gender: {
    男の子: 1, 女の子: 2,
  }
end
