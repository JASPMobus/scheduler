class ApplicationController < Sinatra::Base
	configure do
		set :views, 'app/views'
		set :public_folder, 'public'
		set :layout, 'app/views/layout'
		
		enable :sessions
		set :session_secret, SecureRandom.hex(20)
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

	post "/login" do
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

	post "/account" do
		user = User.find_by(params)

		if user
			session[:user_id] = user.id
			@session = session

			redirect "/account"
		else
			redirect "/error/user-not-found"
		end
	end

	get "/account" do
		if logged_in?
			@user = current_user

			erb :account
		else
			redirect "/login"
		end
	end

	get "/error/:error" do 
		erb :error
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
