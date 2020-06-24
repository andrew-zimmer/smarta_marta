require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'

    enable :sessions
    set :session_secret, ENV['SESSION_SECRET']
  end

  get "/" do
    @api = MartaAPIImporter.new.train_api_call
    erb :mainpage
  end

  helpers do
      def logged_in?
        !!session[:user_id]
      end

      def current_user
        @current_user ||= User.find_by_id(session[:user_id])
      end

      #--------------Marta API Methods--------------------
      def all_trains
        MartaAPIImporter.new.train_api_call
      end

      def array_from_station_name
          all_trains.select{|obj| obj['STATION'] == current_quick_pick.station_name }
      end

      def incoming_trains_based_on_direction_and_or_rail_line
        quick_pick = current_quick_pick
        trains = array_from_station_name

        if quick_pick.direction.nil? && quick_pick.rail_line_name.nil?
            @trains = trains
        elsif !quick_pick.direction.nil? && !quick_pick.rail_line_name.nil?
            @trains = trains.select{|obj| obj['DIRECTION'] == quick_pick.direction}.select{|train| train['LINE'] == quick_pick.rail_line_name}
        elsif quick_pick.direction
            @trains = trains.select{|obj| obj['DIRECTION'] == quick_pick.direction}
        elsif quick_pick.rail_line_name
            @trains = trains.select{|obj| obj['LINE'] == quick_pick.rail_line_name}
        end
      end

      #----------Quick Pick methods-----------------
      def current_quick_pick
        QuickPick.find_by_id(params[:id])
      end

      def create_quick_pick
        qp = current_user.quick_picks.create(station_name: params[:station], alias: params[:alias])
        if params[:alias] == '' || params[:alias].nil?
          qp
        else
          qp.alias = params[:alias]
        end
      end

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

      #-------User Chronicles----------------
      def create_user_chronicle
        chronicle = current_user.user_chronicles.build(station_name: current_quick_pick.station_name)
        if params[:direction] == '' && params[:line] == ''
            chronicle.direction = 'No direction'
            chronicle.rail_line_name = 'No rail-line'
        elsif params[:line] != '' && params[:direction] == ''
            chronicle.direction = 'No direction'
            chronicle.rail_line_name = params[:line]
        elsif parmas[:line] == '' && params[:direction] != ''
          chronicle.direction = params[:direction]
          chronicle.rail_line_name = 'No rail-line'
        end
        chronicle.save
      end

  end



end
