class User < ActiveRecord::Base
    #Stores passwords securely
    has_secure_password

    #has appointments
    has_many :appointments

    #Returns the user's first and last names with a space in between as a string
    def full_name
        "#{self.first_name} #{self.last_name}"
    end

    #Adds in any appointments that this user is the provider for
    def appointments
        pre_providing = super

        providing = Appointments.all.filter { |appointment| appointment.provider_id = self.id }

        pre_providing + providing
    end

    #Updates the user
    def update(params)
       #Grabs all of the info
        first_name  = params["first_name"]
        last_name   = params["last_name"]
        kind        = params["kind"]
        notes       = params["notes"]
        
        #Checks each one individually to see if it's in there. If it is, it updates.
		if first_name
            self.first_name = first_name
        end
        if last_name
            self.last_name = last_name
        end
        if kind
            self.kind = kind
        end
        if notes
            self.notes = notes
        end

        #Then we save at the end to store the changes.
        self.save
    end

    #Checks that the passwords match and are of the proper format, and that the username isn't already taken.
    def self.can_create(params)
        if !acceptable_password?(params["password1"])
            return "bad-password"
        elsif params[:password1] != params["password2"]
            return "password-confirmation"
        elsif username_not_taken?(params["username"])
            return "username-already-taken"
        end
    end

    #Check to see if the username is already taken
    def self.username_not_taken?(username)
        !find_by(username: username)
    end

    #We don't have fields for notes or usertype, because the user can't choose these at creation
    def self.create(params)
        #This is used to make sure we made the user object
        confirm = User.all.length
        #Then we try to make it
        super

        #Finally, if the user was made, we give it a type and empty notes
        if User.all.length > confirm
            #selects the new user
            user = User.all[-1]
            
            #If it's the first user, automatically make it admin, otherwise it's just a base user.
            if User.all.length == 1
                user.kind = "admin"
            else
                user.kind = "user"
            end
            user.notes = "None."
        end

        #Save the user after updating it with the new fields
        user.save
    end

    #Checks to see if this user has an appointment at this time
    def has_appointment?(time)
        true
    end

    private

    #used for self#acceptable_password?
    LOWER   = "a b c d e f g h i j k l m n o p q r s t u v w x y z".split(" ")
    UPPER   = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z".split(" ")
    NUMBER  = "1 2 3 4 5 6 7 8 9 0".split(" ")

    #checks if the string has a lower case letter, an upper case letter, a number, and is at least 8 characters long
    def self.acceptable_password?(str)
        one_of_include?(str, LOWER) && one_of_include?(str, UPPER) && one_of_include?(str, NUMBER) && str.length >= 8
    end

    #checks to see if any of the characters in chars is included in str
    def self.one_of_include?(str, chars)
        #If there's no chars left to check, then none of the chars were in it
        if chars == []
            return false
        #If the first char is in str, we're done
        elsif str.include?(chars[0])
            return true
        end

        #Recursively calling the function after removing the first char
        chars.shift
        
        one_of_include?(str, chars)
    end
end