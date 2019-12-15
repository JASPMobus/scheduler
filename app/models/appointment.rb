class Appointment < ActiveRecord::Base
    belongs_to :users
    has_many :services

    def provider
        User.find(self.provider_id)
    end
end