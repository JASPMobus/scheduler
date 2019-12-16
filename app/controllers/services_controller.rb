class ServicesController < ApplicationController
    get "/services" do
        if logged_in? && current_user.kind!="user"
            @services = Service.all

            erb :'services/index'
        else
            redirect "/error/lacking-privileges"
        end
    end

    get "/services/new" do
        erb :'services/new'
    end
end