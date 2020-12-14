class Dog < ApplicationRecord
  has_one_attached :image

  has_many   :posts, -> { order('id DESC') }, dependent: :destroy
  belongs_to :protector
  has_many   :favorites, dependent: :destroy

  validates :name,                presence: true,
                                  length: { maximum: 20 }
  validates :age,                 presence: true
  validates :address,             presence: true
  validates :gender,              presence: true
  validates :size,                presence: true
  validates :walking,             presence: true
  validates :caretaker,           presence: true
  validates :relationship_dog,    presence: true
  validates :relationship_people, presence: true
  validates :castration,          presence: true
  validates :vaccine,             presence: true
  validates :microchip,           presence: true
  validates :single_people,       presence: true
  validates :senior,              presence: true
  validates :profile,             length: { maximum: 200 }
  validates :conditions,          length: { maximum: 200 }
  validates :health,              length: { maximum: 200 }
  validates :image,               content_type: {
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

  enum age: {
    不明: 1, ３ヶ月未満: 2, ３ヶ月: 3, ４ヶ月: 4, ５ヶ月: 5, ６ヶ月: 6, ７ヶ月: 7, ８ヶ月: 8,
    ９ヶ月: 9, １０ヶ月: 10, １１ヶ月: 11, １歳: 12, ２歳: 13, ３歳: 14, ４歳: 15,
    ５歳: 16, ６歳: 17, ７歳: 18, ８歳: 19, ９歳: 20, １０歳: 21,
    １１歳: 22, １２歳: 23, １３歳: 24, １４歳: 25, １５歳以上: 26,
  }

  enum address: {
    北海道: 1, 青森県: 2, 岩手県: 3, 宮城県: 4, 秋田県: 5, 山形県: 6, 福島県: 7,
    茨城県: 8, 栃木県: 9, 群馬県: 10, 埼玉県: 11, 千葉県: 12, 東京都: 13, 神奈川県: 14,
    新潟県: 15, 富山県: 16, 石川県: 17, 福井県: 18, 山梨県: 19, 長野県: 20,
    岐阜県: 21, 静岡県: 22, 愛知県: 23, 三重県: 24,
    滋賀県: 25, 京都府: 26, 大阪府: 27, 兵庫県: 28, 奈良県: 29, 和歌山県: 30,
    鳥取県: 31, 島根県: 32, 岡山県: 33, 広島県: 34, 山口県: 35,
    徳島県: 36, 香川県: 37, 愛媛県: 38, 高知県: 39,
    福岡県: 40, 佐賀県: 41, 長崎県: 42, 熊本県: 43, 大分県: 44, 宮崎県: 45, 鹿児島県: 46, 沖縄県: 47,
  }

  enum gender: {
    男の子: 1, 女の子: 2,
  }

  enum size: {
    小型犬: 1, 中型犬: 2, 大型犬: 3,
  }

  enum walking: {
    上手: 1, 勉強中: 2,
  }, _prefix: true

  enum caretaker: {
    上手: 1, 勉強中: 2,
  }, _prefix: true

  enum relationship_dog: {
    上手: 1, 勉強中: 2,
  }, _prefix: true

  enum relationship_people: {
    上手: 1, 勉強中: 2,
  }, _prefix: true

  enum castration: {
    済: 1, 未: 2,
  }, _prefix: true

  enum vaccine: {
    済: 1, 未: 2,
  }, _prefix: true

  enum microchip: {
    済: 1, 未: 2,
  }, _prefix: true

  enum senior: {
    応募可能: 1, 応募不可: 2,
  }, _prefix: true

  enum single_people: {
    応募可能: 1, 応募不可: 2,
  }, _prefix: true
end
