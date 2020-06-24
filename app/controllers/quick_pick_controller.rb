class QuickPickController < ApplicationController
    get '/quick_picks' do
        @user = User.find_by(params[:id])

        erb :'/quick_picks/index'
    end

    get '/quick_picks/new' do

        @trains = MartaAPIImporter.new.train_api_call
        erb :'/quick_picks/new'
    end

    post '/quick_picks/new' do
        current_user.quick_picks.create(station_name: params[:station])
        current_user.user_histories.create(station_name: params[:station])

        redirect '/quick_picks'
    end

    get '/quick_picks/:id' do
        @quick_pick = QuickPick.find_by(params[:id])
        trains = MartaAPIImporter.new.train_api_call.select{|station| station['STATION'] == @quick_pick.station_name}

        if @quick_pick.direction.nil? && @quick_pick.rail_line_name.nil?
            @trains = trains
        elsif !@quick_pick.direction.nil? && !@quick_pick.rail_line_name.nil?
            @trains = trains.select{|obj| obj['DIRECTION'] == @quick_pick.direction}.select{|train| train['LINE'] == @quick_pick.rail_line_name}
        elsif @quick_pick.direction
            @trains = trains.select{|obj| obj['DIRECTION'] == @quick_pick.direction}
        elsif @quick_pick.rail_line_name
            @trains = trains.select{|obj| obj['LINE'] == @quick_pick.rail_line_name}
        end


        erb :'quick_picks/show'
    end

    get '/quick_picks/:id/edit' do
        @quick_pick = QuickPick.find_by(params[:id])
        @trains = MartaAPIImporter.new.train_api_call
        erb :'quick_picks/edit'
    end

    patch '/quick_picks/:id' do

        quick_pick = QuickPick.find_by(params[:id])
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
        current_user.user_histories.create()
        quick_pick.save

        redirect "/quick_picks/#{quick_pick.id}"
    end
end
