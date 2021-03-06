class ServicesController < ApplicationController
    get "/services" do
        if logged_in? && current_user.kind!="user"
            @services = StandardService.all.sort { |s1, s2| s1.name <=> s2.name }

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
        service = StandardService.create(params)

        redirect "/services/#{service.id}"
    end

    get "/services/:id" do
        if logged_in? && current_user.kind!="user"
            @service = StandardService.find(params[:id])

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
            @service = StandardService.find(params[:id])

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
        @service = StandardService.find(params[:id])

        if @service
            @service.update(params)

            redirect "/services/:id"
        else
            redirect "/error/invalid-service"
        end
    end

    delete "/services/:id" do
		#Finds the service
		@service = StandardService.find(params[:id])

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