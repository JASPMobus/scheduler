class Service < ActiveRecord::Base 
    #A setter method added for readability
    def alter_fee(new_fee)
        self.price = new_fee
    end
end