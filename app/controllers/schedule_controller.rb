class ScheduleController < ApplicationController
		get "/schedule" do
		#grabs all of the providers
		@providers = User.all.filter { |user| user.kind == "provider" }

		puts @providers

		#The schedule page
		erb :'schedule/index'
	end
end