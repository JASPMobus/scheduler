class AppointmentsController < ApplicationController
    get "/appointments/new" do
        if logged_in?
            @date           = session["date"]
            @time           = session["time"]
            @provider_id    = session["provider_id"].to_i
            session.delete("date")
            session.delete("time")
            session.delete("provider_id")

            #grabs all of the providers
            @providers = User.all.filter { |user| user.kind == "provider" }

            erb :'appointments/new'
        else
            session.delete("date")
            session.delete("time")
            session.delete("provider_id")
            
            redirect "/login"
        end
    end

    get "/appointments/new/:info" do
        session["date"]         = params[:info].split(",")[0]
        session["time"]         = params[:info].split(",")[1]
        session["provider_id"]  = params[:info].split(",")[2]
        @session = session

        redirect "/appointments/new"
    end

    post "/appointments" do
        #checks that the input time is acceptable format
        time_check = Temporal.acceptable_time?(params, current_user)

        if time_check.class != String
            appointment = Appointment.create(params, current_user)
    
            if current_user.kind != "user"
                redirect "/appointments"
            else
                redirect "/account/appointments" 
            end
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
        @appointment = Appointment.find(params[:id])

        if logged_in? && (current_user.kind!="user" || @appointment.user==current_user)
            @user = current_user

            if @user.kind=="provider" && @appointment.provider!=@user && @appointment.user!=@user
                redirect "/appointments"
            else 
                erb :'appointments/appointment'
            end
        else
            redirect "/error/lacking-privileges"
        end
    end

    get "/appointments/:id/edit" do
        if logged_in? && current_user.kind!="user"
            @user = current_user
            @providers = User.all.filter { |user| user.kind == "provider" }
            @services = Service.all.filter { |service| service.standard }
            @appointment = Appointment.find(params[:id])

            erb :'appointments/edit'
        else
            redirect "/error/lacking-privileges"
        end
    end

    patch "/appointments/:id" do
		#Finds the appointment
        @appointment = Appointment.find(params[:id])

		if logged_in? && current_user.kind!="user"
            if @appointment
                #checks that the input time is acceptable format
                time_check = Temporal.acceptable_time?(params, @appointment.user, @appointment)

                if time_check.class != String
                    #Then updates them
                    @appointment.update(params)

                    #Then returns to their user view page
                    redirect "/appointments/#{params[:id]}"
                else
                    redirect "/error/#{time_check}"
                end
            else 
                redirect "/error/appointment-not-found"
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