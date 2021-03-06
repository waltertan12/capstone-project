class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence:true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 3, allow_nil: true}

  attr_reader :password

  has_many(
    :uploaded_songs,
    class_name: "Song",
    foreign_key: :user_id,
    primary_key: :id
  )
  has_many(
    :liked_songs,
    class_name: "SongLike",
    foreign_key: :user_id,
    primary_key: :id
  )
  has_many(
    :followers_model,
    class_name: "UserFollow",
    foreign_key: :follower_id,
    primary_key: :id
  )
  has_many(
    :followers,
    through: :followers_model,
    source: :followee
  )
  has_many(
    :followees_model,
    class_name: "UserFollow",
    foreign_key: :followee_id,
    primary_key: :id
  )
  has_many(
    :followees,
    through: :followees_model,
    source: :follower
  )

  has_many(
    :followee_songs,
    through: :followees,
    source: :uploaded_songs
  )



  after_initialize :ensure_session_token

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil unless user && user.valid_password?(password)
    user
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def valid_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end
  private

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

end
