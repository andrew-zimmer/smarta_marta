class QuickPickController < ApplicationController
    get '/quick_picks' do
        @user = User.find_by(params[:id])

        erb :'/quick_picks/index'
    end

    get '/quick_picks/new' do

        @trains = all_trains
        erb :'/quick_picks/new'
    end

    post '/quick_picks/new' do

        create_quick_pick
        current_user.user_chronicles.build(station_name: params[:station])

        redirect '/quick_picks'
    end

    get '/quick_picks/:id' do
        if logged_in?
            if current_user.quick_picks.any?{|obj| obj.id == params[:id]}
                @quick_pick = current_quick_pick
                @trains = incoming_trains_based_on_direction_and_or_rail_line
                erb :'quick_picks/show'
            else
                redirect '/quick_picks'
            end
        else
            redirect '/users/log_in'
        end
    end

    get '/quick_picks/:id/edit' do
        if logged_in?
            @quick_pick = current_quick_pick
            @trains = all_trains
            erb :'quick_picks/edit'
        else
            redirect '/users/log_in'
        end
    end

    patch '/quick_picks/:id' do
        quick_pick = current_quick_pick
        update_quick_pick

        create_user_chronicle


        redirect "/quick_picks/#{quick_pick.id}"
    end

    delete '/quick_picks/:id/delete' do
        quick_pick = current_quick_pick
        quick_pick.delete
        redirect '/quick_picks'
    end
end
