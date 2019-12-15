class AccountController < ApplicationController
        get "/account" do
		#If you're logged in, we store your info and go to the user page
		if logged_in?
			@user = current_user

			erb :'account/index'
		#Otherwise, we redirect them to the login page
		else
			redirect "/login"
		end
    end
    
    get "/account/edit" do
		#If you're logged in, we store your info and go to the user page
		if logged_in?
			@user = current_user

			erb :'account/edit'
		#Otherwise, we redirect them to the login page
		else
			redirect "/login"
        end
    end

    patch "/account" do
        if User.username_not_taken?(params["username"])
            #Finds the user
            @user = User.find_by(username: params[:username])

            #Then updates them
            @user.update(params)

            #Then goes back to their account
            redirect "/account"
        else
            redirect "/error/username-already-taken"
        end
    end
    
    get "/account/appointments" do
		#If you're logged in, we store your info and go to your appointments page
		if logged_in?
            @user = current_user
            @appointments = @user.appointments

			erb :'account/appointments'
		#Otherwise, we redirect them to the login page
		else
			redirect "/login"
        end
    end
end