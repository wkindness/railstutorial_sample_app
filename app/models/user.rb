class User < ApplicationRecord
  # アクセサ（インスタンス変数を外部から変更できる）
  attr_accessor :remember_token, :activation_token
  # emailは登録前に小文字に変換
  before_save   :downcase_email #ファイル下のprivateで設定
  # ユーザ作成時に有効化トークンとダイジェスト作成
  before_create :create_activation_digest #ファイル下のprivateで設定

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
  # passwordは必須、6文字以上、更新時は空許可
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

    # メールアドレス全体を小文字に変換
    def downcase_email
      email.downcase!
    end

    # 有効化トークン作成とそこからダイジェストも作成
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end



end
