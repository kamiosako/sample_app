class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

 #messages
  has_many :sent_messages,
  :class_name => 'Message',
  :primary_key=>'user_id',
  :foreign_key => 'sender_id',
  :order => "messages.created_at DESC",
  :conditions => ["messages.sender_deleted = ?", false]

  has_many :received_messages,
   :class_name  => 'Message',
   :primary_key => 'user_id',
   :foreign_key => 'recepient_id',
   :order       => "messages.created_at DESC",
   :conditions   => ["messages.recepient_deleted = ?", false]
 #messages end

  def unread_messages?
   unread_message_count > 0 ? true : false
  end

  # Returns the number of unread messages for this user
   def unread_message_count
   eval 'messageas.count(:conditions => ["recepient_id = ? AND read_at IS NULL", self.user_id])'
   end

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name,  presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
 
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end  

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
