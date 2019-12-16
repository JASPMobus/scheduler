class Service < ActiveRecord::Base 
    belongs_to :appointment

    def self.clone(service, appointment_id)
        new_service = Service.new

        new_service.name            = service.name
        new_service.price           = service.price
        new_service.description     = service.description
        new_service.appointment_id  = appointment_id

        new_service.save
    end

    def self.attach(services, appointment_id)
        services.each do |id, amount|
            id = id.to_i
            amount = amount.to_i

            #grab the service template
            service             = StandardService.find(id.to_i)
            
            #check how many already exist
            already_made        = Service.all.filter { |check| check.name==service.name && check.appointment_id==appointment_id  }
            already_made_amount = already_made.length

            if amount < already_made_amount
                difference = already_made_amount - amount

                difference.times do
                    already_made.shift
                end
            elsif amount > already_made_amount
                difference = amount - already_made_amount

                difference.times do
                    clone(service, appointment_id)
                end
            end
        end
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