class UserController < ApplicationController
    get '/users/log_in' do
        erb :'/users/log_in'
    end

    post '/users/log_in' do
        user = User.find_by_email(params[:email])
        if user && user.authenticate(params[:password])
        #check that their password was correct
            session[:user_id] = user.id    # log them in
            redirect to '/quick_picks'
        else
            redirect '/log_in'
        end
    end

    get '/users/sign_up' do
        erb :'/users/sign_up'
    end

    post '/users/sign_up' do
        user = User.new(params) #create our user
        binding.pry
        if user.save
            session[:user_id] = user.id    # log them in

            redirect to '/quick_picks'
        else
            @error = user.errors.full_messages.join("  -  ")
            erb :'users/sign_up'
        end
    end

    get '/logout' do
        session.clear
        redirect '/users/log_in'
    end
end
