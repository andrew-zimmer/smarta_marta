class UserChronicleController < ApplicationController
    get '/user_chronicles' do
        if logged_in?
            if current_user.id == session[:user_id]
                @chronicles = current_user.user_chronicles.all
                erb :'user_chronicles/index'
            else
                redirect '/'
            end
        else
            redirect '/'
        end
    end
end
