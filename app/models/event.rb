class Event < ApplicationRecord
  belongs_to :protector

  validates :protector_id, presence: true
  validates :due_on,       presence: true
  validates :start_at,     presence: true
  validates :finish_at,    presence: true
  validates :prefecture,   presence: true
  validates :address,      presence: true
  validates :content,      length: { maximum: 200 }

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  enum prefecture: {
    北海道: 1, 青森県: 2, 岩手県: 3, 宮城県: 4, 秋田県: 5, 山形県: 6, 福島県: 7,
    茨城県: 8, 栃木県: 9, 群馬県: 10, 埼玉県: 11, 千葉県: 12, 東京都: 13, 神奈川県: 14,
    新潟県: 15, 富山県: 16, 石川県: 17, 福井県: 18, 山梨県: 19, 長野県: 20,
    岐阜県: 21, 静岡県: 22, 愛知県: 23, 三重県: 24,
    滋賀県: 25, 京都府: 26, 大阪府: 27, 兵庫県: 28, 奈良県: 29, 和歌山県: 30,
    鳥取県: 31, 島根県: 32, 岡山県: 33, 広島県: 34, 山口県: 35,
    徳島県: 36, 香川県: 37, 愛媛県: 38, 高知県: 39,
    福岡県: 40, 佐賀県: 41, 長崎県: 42, 熊本県: 43, 大分県: 44, 宮崎県: 45, 鹿児島県: 46, 沖縄県: 47,
  }

  scope :paginate, -> (p) { page(p[:page]) }

  scope :search, -> (search_params) do
    return if search_params.blank?

    prefecture_select(search_params[:prefecture]).
      due_on_from(search_params[:due_on_from]).
      due_on_to(search_params[:due_on_to])
  end

  scope :prefecture_select, -> (prefecture) { where(prefecture: prefecture) if prefecture.present? }
  scope :due_on_from, -> (from) { where('? <= due_on', from) if from.present? }
  scope :due_on_to, -> (to) { where('due_on <= ?', to) if to.present? }
end
