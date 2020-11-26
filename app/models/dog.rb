class Dog < ApplicationRecord
  has_one_attached :image

  belongs_to :protector

  enum age: {
    ３ヶ月未満: 1, ３ヶ月: 2, ４ヶ月: 3, ５ヶ月: 4, ６ヶ月: 5, ７ヶ月: 6, ８ヶ月: 7,
    ９ヶ月: 8, １０ヶ月: 9, １１ヶ月: 10, １歳: 11, ２歳: 12, ３歳: 13, ４歳: 14,
    ５歳: 15, ６歳: 16, ７歳: 17, ８歳: 18, ９歳: 19, １０歳: 20,
    １１歳: 15, １２歳: 16, １３歳: 17, １４歳: 18, １５歳以上: 19,
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

  enum relationsip_dog: {
    上手: 1, 勉強中: 2,
  }, _prefix: true

  enum relationsip_people: {
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
