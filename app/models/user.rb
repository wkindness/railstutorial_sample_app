class User < ApplicationRecord
  # emailは登録時に小文字に変換
  before_save { self.email = email.downcase }

  # nameは必須、50文字まで
  validates :name,  presence: true, length: { maximum: 50 }

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

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end
