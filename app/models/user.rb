class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /[\w+\-.]*@(ignitemedia.com)/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }

    has_secure_password
    validates :password, length: { minimum: 6 }
  
	@secret = ENV["SECRET_PASS"]
	validates :admin_key, inclusion: { in: %w(@secret), message: "The key is incorrect" }	
end
