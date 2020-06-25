class QuickPickController < ApplicationController
    get '/quick_picks' do
        if logged_in?
            if check_current_user_via_session_id
                @user = current_user
                @trains = all_trains
                erb :'/quick_picks/index'
            else
                #nice try
                redirect '/'
            end
        else
            flash_message_log_in
            redirect '/'
        end
    end

    get '/quick_picks/new' do
        if logged_in?
            if check_current_user_via_session_id
                @trains = all_trains
                erb :'/quick_picks/new'
            else
                #nice try
                redirect '/'
            end
        else
            flash_message_log_in
            redirect '/'
        end
    end

    post '/quick_picks/new' do
        if logged_in?
            if check_current_user_via_session_id
                if create_quick_pick
                    create_user_chronicle
                    redirect "/quick_picks/#{current_user.quick_picks[-1].id}/edit"
                else
                    redirect '/quick_picks'
                end
            else
                #nice try
                redirect '/'
            end
        else
            flash_message_log_in
            redirect '/'
        end
    end

    get '/quick_picks/:id' do
        if logged_in?
            if compare_user_and_quick_pick_owner && check_current_user_via_session_id
                @quick_pick = current_quick_pick
                @trains = incoming_trains_based_on_direction_and_or_rail_line
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
            if compare_user_and_quick_pick_owner && check_current_user_via_session_id
                @quick_pick = current_quick_pick
                @trains = all_trains
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
            if compare_user_and_quick_pick_owner && check_current_user_via_session_id
                if valid_direction_and_or_rail_line
                    update_quick_pick
                    create_user_chronicle
                    redirect "/quick_picks/#{params[:id]}"
                else
                    redirect '/quick_picks'
                end
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
            if check_current_user_via_session_id && compare_user_and_quick_pick_owner
                quick_pick = current_quick_pick
                quick_pick.delete
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
