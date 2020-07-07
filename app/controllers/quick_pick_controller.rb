class QuickPickController < ApplicationController
    get '/quick_picks' do
        redirect_if_not_logged_in
        @trains = all_trains
        erb :'/quick_picks/index'
    end

    get '/quick_picks/new' do
        redirect_if_not_logged_in
        erb :'/quick_picks/new'
    end

    post '/quick_picks/new' do
        redirect_if_not_logged_in
        redirect_if_cant_create_quick_pick
        redirect "/quick_picks/#{current_user.quick_picks[-1].id}/edit"
    end

    get '/quick_picks/:id' do
        redirect_if_not_logged_in
        redirect_if_user_is_not_qp_owner
        erb :'quick_picks/show'
    end

    get '/quick_picks/:id/edit' do
        redirect_if_not_logged_in
        redirect_if_user_is_not_qp_owner
        erb :'quick_picks/edit'
    end

    patch '/quick_picks/:id' do
        redirect_if_not_logged_in
        redirect_if_user_is_not_qp_owner
        redirect_has_invalid_direction_or_rail_line
        update_quick_pick
        redirect "/quick_picks/#{params[:id]}"
    end

    delete '/quick_picks/:id/delete' do
        redirect_if_not_logged_in
        redirect_if_user_is_not_qp_owner
        current_quick_pick.delete
        redirect '/quick_picks'
    end




    private
    #------user varification------------
    def compare_user_and_quick_pick_owner
        current_user == current_quick_pick.user
    end


    #------quick pick update and create methods---------
    def update_quick_pick
        quick_pick = current_quick_pick
        if params[:direction] == ''
            quick_pick.direction = nil
        else
            quick_pick.direction = params[:direction]
        end

        if params[:line] == ''
            quick_pick.rail_line_name = nil
        else
            quick_pick.rail_line_name = params[:line]
        end

        if params[:alias] == ''
            quick_pick.alias = nil
        else
            quick_pick.update(alias: params[:alias])
        end
        quick_pick.save
      end

      def create_quick_pick
        if valid_station_name?
          current_user.quick_picks.create(station_name: params[:station], alias: params[:alias])
        else
          false
        end
      end


      #-----------MARTA API and train array methods----------------

      def valid_station_name?
        all_trains.any? {|obj| obj['STATION'] == params[:station]}
      end

      def valid_direction_and_or_rail_line
        if params[:direction] == '' || params[:direction].nil?
          true
        else
          if array_from_station_name.any?{|obj| obj['DIRECTION'] == params[:direction]}
            true
          else
            return false
          end
        end

        if params[:line] == '' || params[:direction].nil?
          true
        else
          if array_from_station_name.any?{|obj| obj['LINE'] == params[:line]}
            true
          else
            return false
          end
        end
      end
end
