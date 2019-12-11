class User < ActiveRecord::Base
    has_secure_password

    LOWER = "a b c d e f g h i j k l m n o p q r s t u v w x y z".split(" ")
    UPPER = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z".split(" ")
    NUMBER = "1 2 3 4 5 6 7 8 9 0".split(" ")

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