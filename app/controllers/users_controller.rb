class UsersController < ApplicationController
	configure do
		set :layout, 'app/views/layout'
	end

	get "/users" do
		#Only employees can view the users page
		if logged_in? && current_user.kind!="user"
			@users = User.all

			erb :'users/index'
		#If you aren't logged in as an admin, you can't view it
		else
			redirect "/error/lacking-privileges"
		end
	end

    get "/users/:username" do
		#Only employees can view the users page
		if logged_in? && current_user.kind!="user"
        #Finds the user
		@user = User.find_by(username: params[:username])

        if @user
            erb :'users/user'
        else
            redirect "/error/invalid-user-selected"
        end 
		#If you aren't logged in as an admin, you can't view it
		else
			redirect "/error/lacking-privileges"
		end
	end

	get "/users/:username/edit" do
		#Only employees can view the users page
		if logged_in? && current_user.kind!="user"
			#Finds the user
			@user = User.find_by(username: params[:username])
			@viewer = current_user

			if @user
				erb :'users/edit'
			else
				redirect "/error/invalid-user-selected"
			end 
			#If you aren't logged in as an admin, you can't view it
		else
			redirect "/error/lacking-privileges"
		end
	end

	patch "/users/:username" do
		#Finds the user
		@user = User.find_by(username: params[:username])

		#Then updates them
		puts params
		
		kind = params["kind"]
		notes = params["notes"]

		if kind 
			@user.kind = kind
		elsif notes
			@user.notes = notes
		end

		@user.save

		redirect "/users/#{@user.username}"
	end
end