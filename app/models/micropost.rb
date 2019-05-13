class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader

  # user_idは必須
  validates :user_id, presence: true
  # contentは必須、140文字まで
  validates :content, presence: true, length: { maximum: 140 }
  # pictureのサイズ制限
  validate  :picture_size


  
  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end






end
