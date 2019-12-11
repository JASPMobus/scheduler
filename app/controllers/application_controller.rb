class ApplicationController < Sinatra::Base
	configure do
		set :views, 'app/views'
		set :public_folder, 'public'
		set :layout, 'app/views/layout'
		
		enable :sessions
		set :session_secret, "H8cZQHxgXjRxpPzEfmXi1MjwBujTe2dW"
	end

	get "/" do
		erb :index
	end

	get "/signup" do
		if logged_in?
			redirect "/account"
		else
			erb :signup 
		end
	end

	post "/signup" do
		check = User.can_create(params)

		if check != String
			#getting rid of the redundant passwords now that we've confirmed them
			params[:password] = params[:password1]
			params.reject! { |k| k=="password1" }
			params.reject! { |k| k=="password2" }

			user = User.create(params)

			redirect "/login"
		end

		redirect "/error/#{check}"
	end

	get "/login" do
		if logged_in?
			redirect "/account"
		else
			erb :login
		end
	end

	post "/login" do
		@user = User.find_by({username: params["username"]})

		if @user 
			if @user.authenticate(params[:password])
				session[:user_id] = @user.id
				@session = session

				redirect "/account"
			else
				redirect "/error/username-password-mismatch"
			end
		else
			redirect "/error/user-not-found"
		end
	end

	get "/account" do
		if logged_in?
			@user = current_user

			erb :account
		else
			redirect "/error/not-logged-in"
		end
	end

	get "/error/:error" do 
		erb :error
	end

	get '/logout' do
		session.clear
		@session = session
	
		redirect "/"
	end

	get "/users" do
		if logged_in? && current_user.type="admin"
			@users = User.all

			erb :'users/index'
		else
			redirect "/error/not-logged-in-as-admin"
		end
	end

	helpers do
		def logged_in?
			!!session[:user_id]
		end
  
		def current_user
			User.find(session[:user_id])
		end
	end
end
