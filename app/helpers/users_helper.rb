module UsersHelper
	def validate_secret(attr_name, secret)
		validates attr_name, inclusion: { in: secret, message: "The key is incorrect" }
	end
end
