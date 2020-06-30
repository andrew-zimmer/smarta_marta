class QuickPickController < ApplicationController
    get '/quick_picks' do
        if logged_in?
            @trains = all_trains
            erb :'/quick_picks/index'
        else
            flash_message_log_in
            redirect '/'
        end
    end

    get '/quick_picks/new' do
        if logged_in?
            erb :'/quick_picks/new'
        else
            flash_message_log_in
            redirect '/'
        end
    end

    post '/quick_picks/new' do
        if logged_in?
            if create_quick_pick
                # create_user_chronicle
                redirect "/quick_picks/#{current_user.quick_picks[-1].id}/edit"
            else
                redirect '/quick_picks'
            end
        else
            flash_message_log_in
            redirect '/'
        end
    end

    get '/quick_picks/:id' do

        if logged_in?
            if compare_user_and_quick_pick_owner
               erb :'quick_picks/show'
            else
                redirect '/quick_picks'
            end
        else
            flash_message_log_in
            redirect '/'
        end
    end

    get '/quick_picks/:id/edit' do
        if logged_in?
            if compare_user_and_quick_pick_owner
                erb :'quick_picks/edit'
            else
                redirect '/quick_picks/log_in'
            end
        else
            flash_message_log_in
            redirect '/'
        end
    end

    patch '/quick_picks/:id' do
        if logged_in?
            if compare_user_and_quick_pick_owner && valid_direction_and_or_rail_line
                update_quick_pick
                # create_user_chronicle
                redirect "/quick_picks/#{params[:id]}"
            else
                redirect '/quick_picks'
            end
        else
            flash_message_log_in
            redirect '/'
        end
    end

    delete '/quick_picks/:id/delete' do
        if logged_in?
            if compare_user_and_quick_pick_owner
                current_quick_pick.delete
                redirect '/quick_picks'
            else

                redirect '/quick_picks'
            end
        else
            flash_message_log_in
            redirect '/'
        end
    end
end
