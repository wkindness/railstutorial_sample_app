class User < ApplicationRecord
  # emailは登録時に小文字に変換
  before_save { self.email = email.downcase }

  # nameは必須、40文字まで
  validates :name,  presence: true, length: { maximum: 40 }

  # emailは必須、255文字まで、メールアドレス形式、重複禁止（大小区別なし）
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # セキュアなpassword
  has_secure_password
  # passwordは必須、6文字以上
  validates :password, presence: true, length: { minimum: 6 }

end
