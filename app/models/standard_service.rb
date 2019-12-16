class StandardService < ActiveRecord::Base 
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