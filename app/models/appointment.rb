class Appointment < ActiveRecord::Base
    belongs_to :users
    has_many :services

    def provider
        User.find(self.provider_id)
    end

    def self.create(params, user)
        #fields
        #t.datetime "start_time"
        #t.string "notes"
        #t.integer "user_id"
        #t.integer "provider_id"
        #t.integer "duration"

        #grabbing the values
        start_time = Temporal.generate_datetime(params["date"], params["time"])
        notes = "" #notes always start empty
        user_id = user.id
        provider_id = params["provider_id"]
        duration = params["duration"]

        #creating the appointment and giving it the values above
        appointment = Appointment.new

        appointment.start_time = start_time
        appointment.notes = notes
        appointment.user_id = user_id
        appointment.provider_id = provider_id
        appointment.duration = duration

        appointment.save
    end
end