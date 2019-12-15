class Appointment < ActiveRecord::Base
    belongs_to :users
    has_many :services

    def provider
        if self.provider_id
            User.find(self.provider_id)
        else 
            User.find(1)
        end
    end

    def user
        User.find(self.user_id)
    end

    def self.create(params, user)
        #fields
        #t.datetime "start_time"
        #t.string "notes"
        #t.integer "user_id"
        #t.integer "provider_id"
        #t.integer "duration"

        #grabbing the values
        start_time  = Temporal.generate_datetime(params["date"], params["time"])
        notes       = "" #notes always start empty
        user_id     = user.id
        provider_id = params["provider_id"]
        duration    = params["duration"]

        #creating the appointment and giving it the values above
        appointment = Appointment.new

        appointment.start_time = start_time
        appointment.notes = notes
        appointment.user_id = user_id
        appointment.provider_id = provider_id
        appointment.duration = duration

        puts appointment 

        appointment.save
    end

    #Updates the user
    def update(params)
        #Grabs all of the info
        start_time  = Temporal.generate_datetime(params["date"], params["time"])
        notes       = params["notes"]
        provider_id = params["provider_id"]
        duration    = params["duration"]
        
        #Checks each one individually to see if it's in there. If it is, it updates.
        if start_time
            self.start_time = start_time
        end
        if notes
            self.notes = notes
        end
        if provider_id
            self.provider_id = provider_id
        end
        if duration
            self.duration = duration
        end

        #Then we save at the end to store the changes.
        self.save
    end
end