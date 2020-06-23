class QuickPickController < ApplicationController
    get '/quick_picks' do
        @user = User.find_by(params[:id])

        erb :'quick_picks/quick_picks'
    end

    get '/quick_picks/new' do
        @trains = MartaAPIImporter.new.train_api_call
        erb :'quick_picks/new'
    end
end
