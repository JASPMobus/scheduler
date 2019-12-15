class Appointment < ActiveRecord::Base
    belongs_to :users
    has_many :services
end