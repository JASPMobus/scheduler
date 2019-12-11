class User < ActiveRecord::Base
    has_secure_password

    #used for self#acceptable_password?
    LOWER = "a b c d e f g h i j k l m n o p q r s t u v w x y z".split(" ")
    UPPER = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z".split(" ")
    NUMBER = "1 2 3 4 5 6 7 8 9 0".split(" ")

    def self.create(params)
        if acceptable_password?(params[:password1])
            if params[password1] == params[:password2]
                user = User.new

                if User.all.length == 0
                    user.type = "admin"
                else
                    user.type = "user"
                end
                user.id = User.all.length + 1
                user.first_name = params[:first_name]
                user.last_name = params[:last_name]
                user.username = params[:username]
                user.password = params[:password1]
                user.notes = ""

                if user.save
                    return user
                else 
                    return "account-creation"
                end
            else 
               return "password-confirmation" 
            end
        else
            return "bad-password"
        end 
    end

    #checks if the string has a lower case letter, an upper case letter, a number, and is at least 8 characters long
    def self.acceptable_password?(str)
        one_of_include?(str, LOWER) && one_of_include?(str, UPPER) && one_of_include?(str, NUMBER) && str.length >= 8
    end

    private

    #checks to see if any of the characters in chars is included in str
    def self.one_of_include?(str, chars)
        if chars == []
            return false
        elsif str.include?(chars[0])
            return true
        end

        chars.shift
        
        one_of_include?(str, chars)
    end
end