class User < ApplicationRecord
  has_one_attached :image
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_many :pets,          dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :protectors, through: :relationships

  validates :name,          presence: true,
                            length: { maximum: 20 }
  validates :email,         length: { maximum: 60 }
  validates :address,       presence: true
  validates :family_people, presence: true
  validates :house,         presence: true
  validates :caretaker,     presence: true
  validates :profile,       length: { maximum: 200 }
  validates :image,         content_type: {
                              in: %w(image/jpeg image/png),
                              message: "jpgまたはpngの画像を添付してください",
                            },
                            size: {
                              less_than: 5.megabytes,
                              message: "5MB以下のファイルを選んでください",
                            }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

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

  enum family_people: {
    １人: 1, ２人: 2, ２〜５人: 3, ５人以上: 4,
  }

  enum house: {
    一戸建て: 1, 集合住宅: 2,
  }

  enum caretaker: {
    無: 1, ３時間未満: 2, ３時間以上５時間未満: 3, ５時間以上８時間未満: 4, ８時間以上: 5,
  }
end
