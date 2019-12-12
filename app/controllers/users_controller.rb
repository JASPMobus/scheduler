class UsersController < ApplicationController
	get "/users" do
		#Only admins can view the users page
		if logged_in? && current_user.kind=="admin"
			@users = User.all

			erb :'users/index'
		#If you aren't logged in as an admin, you can't view it
		else
			redirect "/error/not-logged-in-as-admin"
		end
	end

    get "/users/:username" do
        #Finds the user
        @user = User.find_by(username: params[:username])

        if @user
            erb :'users/user'
        else
            redirect "/error/invalid-user-selected"
        end 
	end
end