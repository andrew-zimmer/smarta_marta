class UserController < ApplicationController
    get '/users/log_in' do
        if logged_in?
            redirect '/quick_picks'
        else
            erb :'/users/log_in'
        end

    end

    post '/users/log_in' do
        if User.find_by_email(params[:email])
            user = User.find_by_email(params[:email])
            if user && user.authenticate(params[:password])
            #check that their password was correct
                session[:user_id] = user.id    # log them in
                redirect to '/quick_picks'
            else
                redirect '/users/log_in'
            end
        else
            flash[:message] = 'Invalid Email Address'
            redirect '/users/log_in'
        end
    end

    get '/users/sign_up' do
        if logged_in?
            redirect '/quick_picks'
        else
            erb :'/users/sign_up'
        end

    end

    post '/users/sign_up' do
        user = User.new(params) #create our user
        if user.save
            session[:user_id] = user.id    # log them in

            redirect to '/quick_picks'
        else
            @error = user.errors.full_messages.join("  -  ")
            erb :'users/sign_up'
        end
    end

    get '/users/logout' do
        session.clear
        redirect '/users/log_in'
    end
end
