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
end