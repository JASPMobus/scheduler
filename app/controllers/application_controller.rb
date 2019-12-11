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
		#TO ADD: check if user logged in
		erb :signup 
	end

	post "/login" do
		user = User.create(params)

		if user.class != String
			session[:user_id] = user.id
			@session = session

			redirect "/account"
		else
			redirect "/error/#{user}"
		end
	end

	get "/account" do
		erb :account
	end

	get "/error/:error" do 
		erb :error
	end
end
