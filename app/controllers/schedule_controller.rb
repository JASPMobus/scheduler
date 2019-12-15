class ScheduleController < ApplicationController
    get "/schedule" do
		#The schedule page
		erb :'schedule/index'
	end
end