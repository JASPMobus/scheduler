class ScheduleController < ApplicationController
	get "/schedule" do
		#grabs all of the providers and the date
		@providers = User.all.filter { |user| user.kind == "provider" }
		@date = Date.today

		#The schedule page
		erb :'schedule/index'
	end

	get "/schedule/:date" do
		check_date = Temporal.check_date(params[:date])
		if check_date.class != String
			#grabs all of the providers and the date
			@providers = User.all.filter { |user| user.kind == "provider" }
			@date = Date.parse(params["date"])

			erb :'schedule/index'

		else 
			redirect "/error/#{check_date}"
		end 
	end
end