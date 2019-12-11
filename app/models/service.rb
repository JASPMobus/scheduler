class Service < ActiveRecord::Base 
    def alter_fee(new_fee)
        self.price = new_fee
    end
end