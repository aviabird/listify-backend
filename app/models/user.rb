class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String


  field :secret_tokens,      type: Hash, default: {
                                        "twitter" => nil
                                        }


  field :access_tokens,      type: Hash, default: {
                                        "twitter" => nil
                                        }

  field :social_logins,      type: Hash, default: { 
                                                    "twitter"  => nil
                                                  }

  field :full_name,          type: String

  has_many :users_lists


  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time


  # TODO: Add Find by email clause
  def self.find_user(attr)
    user = where("social_logins.twitter" => attr[:user_id]).first

    user.update(
      access_tokens: user.access_tokens.merge('twitter' => attr[:access_token]),
      secret_tokens: user.secret_tokens.merge('twitter' => attr[:secret_token])
      ) if user

    user
  end

  def self.create_user(attr)
    user = find_or_create_by(email: attr[:email]) do |u|
             u.password = SecureRandom.hex;
          end

    user.update(
      social_logins: user.social_logins.merge('twitter' => attr[:user_id]),
      access_tokens: user.access_tokens.merge('twitter' => attr[:access_token]),
      secret_tokens: user.secret_tokens.merge('twitter' => attr[:secret_token])
      ) if user

    user
  end
end
