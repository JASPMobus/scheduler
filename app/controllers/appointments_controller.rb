class AppointmentsController < ApplicationController
    get "/appointments/new" do
        #grabs all of the providers
        @providers = User.all.filter { |user| user.kind == "provider" }

        erb :'appointments/new'
    end

    post "/appointments" do
        #checks that the input time is acceptable format
        time_check = Temporal.acceptable_time?(params["time"])

        if time_check.class != "String"
            appointment = Appointment.create(params, current_user)
    
            redirect "/appointments"
        else
            redirect "/error/#{time_check}"
        end
    end

    get "/appointments" do
        if logged_in? && current_user.kind!="user"
            @appointments = Appointment.all

            erb :'appointments/index'  
        else
            redirect "/error/lacking-privileges"
        end
    end

    get "/appointments/:id" do
        if logged_in? && current_user.kind!="user"
            @appointment = Appointment.find(params[:id])

            if current_user.kind=="provider" && @appointment.provider!=current_user
                redirect "/appointments"
            else 
                erb :'appointments/appointment'
            end
        else
            redirect "/error/lacking-privileges"
        end
    end

    patch "/appointments/:id" do
		#Finds the appointment
		@appointment = Appointment.find(params[:id])

		if logged_in? && current_user.kind!="user"
			if @user
				#Then updates them
				@user.update(params)

				#Then returns to their user view page
				redirect "/appointments/:id"
			else
				redirect "/error/user-not-found"
			end
		else 
			redirect "/error/lacking-privileges"
		end
	end

    delete "/appointments/:id" do
		#Finds the appointment
		@appointment = Appointment.find(params[:id])

		if logged_in? && current_user.kind!="user" && current_user.kind!="provider"
			if @appointment
				@appointment.delete

				redirect "/appointments"
			else
				redirect "/error/appointment-not-found"
			end
		else
			redirect "/error/lacking-privileges"
		end 
	end
end