require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET']
    register Sinatra::Flash

    set :show_exceptions, false
  end

  error 400...500 do
    erb :'/errors/400_error'
  end

  error 500...512 do
    erb :'/errors/500_error'
  end

  get "/" do
    if logged_in?
      redirect '/quick_picks'
    else
      erb :mainpage
    end
  end

  error ActiveRecord::RecordNotFound do
    redirect '/'
  end

  helpers do
      #-------------user verifications----------------------
      def logged_in?
        !!session[:user_id]
      end

      def current_user
        @current_user ||= User.find_by_id(session[:user_id])
      end

      #--------------Marta API Methods--------------------
      def all_trains
        @all_trains ||= MartaAPIImporter.new.train_api_call
      end



      def all_unique_stations_from_all_trains
        all_trains.collect{|train| train['STATION']}.uniq.sort
      end

      #array of train hashes that have the current station as a destination
      def array_from_station_name
          all_trains.select{|obj| obj['STATION'] == current_quick_pick.station_name}
      end

      #array of directions based on array given from array_from_station_name method
      def collect_all_directions_for_current_station
        array_from_station_name.collect{|train| train['DIRECTION']}.uniq.sort
      end



      def incoming_trains_based_on_direction_and_or_rail_line
        @trains ||=
          if current_quick_pick.direction.nil? && current_quick_pick.rail_line_name.nil?
              array_from_station_name
          elsif !current_quick_pick.direction.nil? && !current_quick_pick.rail_line_name.nil?
              array_from_station_name.select{|obj| obj['DIRECTION'] == current_quick_pick.direction}.select{|train| train['LINE'] == current_quick_pick.rail_line_name}
          elsif current_quick_pick.direction
              array_from_station_name.select{|obj| obj['DIRECTION'] == current_quick_pick.direction}
          elsif current_quick_pick.rail_line_name
              array_from_station_name.select{|obj| obj['LINE'] == current_quick_pick.rail_line_name}
          end
      end

      #----------Quick Pick methods-----------------
      def current_quick_pick
        @current_quick_pick ||= QuickPick.find(params[:id])
      end
   end



  private
  def redirect_if_not_logged_in
    if !logged_in?
      flash[:message] = "You're not logged in!"

      redirect to '/users/log_in'
    end
  end

  def redirect_if_cant_create_quick_pick
    if !create_quick_pick
      flash[:message] = "Could not create quick pick."
      redirect '/quick_picks'
    end
  end


  def redirect_if_user_is_not_qp_owner
    if !compare_user_and_quick_pick_owner
      redirect '/quick_picks'
    end
  end

  def redirect_has_invalid_direction_or_rail_line
    if !valid_direction_and_or_rail_line
      redirect '/quick_picks'
    end
  end
end
