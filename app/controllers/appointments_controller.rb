class AppointmentsController < ApplicationController
    get "/appointments/new" do
        #grabs all of the providers
        @providers = User.all.filter { |user| user.kind == "provider" }
        
        erb :'appointments/new'
    end
end