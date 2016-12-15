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

  has_many :lists


  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time


  def self.find_or_create(attr)

    user = find_or_create_by(email: attr[:email]) do |u|
              u.password = SecureRandom.hex;
          end

    user.update(
      access_tokens: user.access_tokens.merge('twitter' => attr[:access_token]),
      secret_tokens: user.secret_tokens.merge('twitter' => attr[:secret_token])
      )

    user
  end

  # NOTE: Currently Not using this method , Just for reference
  # Takes oAuth object as params 
  # Retrive user data from oauth object
  # find or create the user and if user present
  # update the user with new values mainly access_token 
  def self.create_or_update(oauth)
    oauth.get_data
    data = oauth.data

    user = where("social_logins.#{oauth.provider}" => data[:id]).first || 
      find_or_create_by(email: data[:email]) do |u|
        u.password =  SecureRandom.hex
      end

    user.update(
      full_name: oauth.get_full_name,
      email: data[:email],
      social_logins: user.social_logins.merge(oauth.provider => data[:id]),
      access_tokens: user.access_tokens.merge(oauth.provider => data[:access_token])
    )
    
    user
  end
end
