class User < ActiveRecord::Base
    has_secure_password

    LOWER = "abcdefghijklmnopqrstuvwxyz"
    UPPER = LOWER.upper
    NUMBER = "1234567890"

    def self.acceptable_password?(str)
        string_include?(str, LOWER)
    end

    private

    #checks to see if any of the characters in chars is included in str
    def self.string_include?(str, chars)

    end 
end