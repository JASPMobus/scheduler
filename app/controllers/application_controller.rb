class ApplicationController < Sinatra::Base
	configure do
		set :views, 'app/views'
		set :public_folder, 'public'
		set :layout, 'app/views/layout'
		
		enable :sessions
		set :session_secret, "H8cZQHxgXjRxpPzEfmXi1MjwBujTe2dW"
	end

	get "/" do
		if logged_in?
			@user = current_user
		else
			@user = nil
		end

		#The home page
		erb :index
	end

	get "/signup" do
		#If you're already logged in, just go to account.
		if logged_in?
			redirect "/account"
		#Otherwise, go to signup page.
		else
			erb :signup 
		end
	end

	post "/signup" do
		#Runs the signup query through some checks to make sure the user can be created
		check = User.can_create(params)

		if check.class != String
			#getting rid of the redundant passwords now that we've confirmed them
			params[:password] = params[:password1]
			params.reject! { |k| k=="password1" }
			params.reject! { |k| k=="password2" }

			#actually creating the user
			user = User.create(params)

			#now the user can be logged in
			redirect "/login"
		end

		#If the check class is a string, that's an error.
		redirect "/error/#{check}"
	end

	get "/login" do
		#If you're logged in already, just go to account.
		if logged_in?
			redirect "/account"
		#Otherwise, go to the login page
		else
			erb :login
		end
	end

	post "/login" do
		#First, we find the user by their username
		@user = User.find_by({username: params["username"]})

		#If they're found, check if their password works
		if @user 
			#If it does, then go to account
			if @user.authenticate(params[:password])
				session[:user_id] = @user.id
				@session = session

				redirect "/account"
			#If it doesn't, then that's an error
			else
				redirect "/error/username-password-mismatch"
			end
		#If they're not, then that's an error
		else
			redirect "/error/user-not-found"
		end
	end

	get "/error/:error" do 
		#The error page
		erb :error
	end

	get '/logout' do
		#Clearing the session stops storing the logged in user's ID--so they can't be called on anymore.
		session.clear
		@session = session

		#Go to the home page afterwards
		redirect "/"
	end

	get "/management" do
		if logged_in? && current_user.kind!="user"
			erb :management
		else
			redirect "/error/lacking-privileges"
		end
	end

	get "/clear_all" do
		if logged_in? && current_user.kind=="admin"
			Service.all.each do |s|
				s.delete
			end

			StandardService.all.each do |ss|
				ss.delete
			end

			Appointment.all.each do |a|
				a.delete
			end

			User.all.each do |u|
				u.delete
			end

			redirect "/logout"
		else
			redirect "/error/lacking-privileges"
		end
	end

	helpers do
		#If the session has a user_id, then a user must be logged in
		def logged_in?
			!!session[:user_id]
		end
  
		#This is the user that is logged in, if there is one.
		def current_user
			User.find(session[:user_id])
		end
	end
end
