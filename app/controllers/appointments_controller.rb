class AppointmentsController < ApplicationController
    get "/appointments/new" do
        #grabs all of the providers
        @providers = User.all.filter { |user| user.kind == "provider" }

        erb :'appointments/new'
    end

    post "/appointments" do
        puts params

        redirect "/appointments"
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