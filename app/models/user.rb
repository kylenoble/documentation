class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /[\w+\-.]*@(ignitemedia.com)/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }

    has_secure_password
    validates :password, length: { minimum: 6 }
  
  def validate_secret(attr_name, secret)
		validates attr_name, inclusion: { in: secret, message: "The key is incorrect" } }
	end 	

  @secret = ENV["SECRET_PASS"]
	validate_secret :admin_key, @secret
end
