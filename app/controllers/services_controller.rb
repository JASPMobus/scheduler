class ServicesController < ApplicationController
    get "/services" do
        if logged_in? && current_user.kind!="user"
            @services = Service.all.filter { |service| service.standard }

            erb :'services/index'
        else
            redirect "/error/lacking-privileges"
        end
    end

    get "/services/new" do
        if logged_in? && current_user.kind=="admin"
            erb :'services/new'
        else
            redirect "/error/lacking-privileges"
        end
    end

    post "/services" do
        service = Service.create(params)

        redirect "/services/#{service.id}"
    end

    get "/services/:id" do
        if logged_in? && current_user.kind!="user"
            @service = Service.find(params[:id])

            if @service
                erb :'services/service'
            else
                redirect "/error/invalid-service"
            end
        else
            redirect "/error/lacking-privileges"
        end
    end

    get "/services/:id/edit" do
        if logged_in? && current_user.kind=="admin"
            @service = Service.find(params[:id])

            if @service
                erb :'services/edit'
            else
                redirect "/error/invalid-service"
            end
        else
            redirect "/error/lacking-privileges"
        end
    end

    patch "/services/:id" do 
        @service = Service.find(params[:id])

        if @service
            @service.update(params)

            redirect "/services/:id"
        else
            redirect "/error/invalid-service"
        end
    end

    delete "/services/:id" do
		#Finds the service
		@service = Service.find(params[:id])

		if logged_in? && current_user.kind=="admin"
			if @service
				@service.delete

				redirect "/services"
			else
				redirect "/error/service-not-found"
			end
		else
			redirect "/error/lacking-privileges"
		end 
    end
end