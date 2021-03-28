class JsonWebToken
  def self.decode(token)
		@result = '' 
		begin
    	@result = HashWithIndifferentAccess.new(JWT.decode(token, ENV["SECRET_KEY_BASE"])[0])
		rescue => e
			@result = e
		ensure
			return @result
		end
	end
end