class UsersController < ApplicationController
	get "/users" do
		#Only employees can view the users page
		if logged_in? && current_user.kind!="user"
			@users = User.all.sort { |u1, u2| u1.full_name <=> u2.full_name }

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
				redirect "/error/user-not-found"
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
				redirect "/error/user-not-found"
			end 
			#If you aren't logged in as an admin, you can't view it
		else
			redirect "/error/lacking-privileges"
		end
	end

	patch "/users/:username" do
		#Finds the user
		@user = User.find_by(username: params[:username])

		if logged_in? && current_user.kind!="user"
			if @user
				#Then updates them
				@user.update(params)

				#Then returns to their user view page
				redirect "/users/#{@user.username}"
			else
				redirect "/error/user-not-found"
			end
		else 
			redirect "/error/lacking-privileges"
		end
	end

	delete "/users/:username" do
		#Finds the user
		@user = User.find_by(username: params[:username])

		if logged_in? && current_user.kind!="user"
			if @user
				@user.delete

				redirect "/users"
			else
				redirect "/error/user-not-found"
			end
		else
			redirect "/error/lacking-privileges"
		end 
	end
end