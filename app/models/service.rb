class Service < ActiveRecord::Base 
    belongs_to :appointment
    
    #A setter method added for readability
    def alter_fee(new_fee)
        self.price = new_fee
    end

    def self.create(params, standard = true)
        service = super(params)

        service.standard = standard

        service.save

        service
    end

    #Updates the service
    def update(params)
        #Grabs all of the info
        name        = params["name"]
        price       = params["price"]
        description = params["description"]
         
         #Checks each one individually to see if it's in there. If it is, it updates.
         if name
             self.name = name
         end
         if price
             self.price = price
         end
         if description
             self.description = description
         end
 
         #Then we save at the end to store the changes.
         self.save
     end
end