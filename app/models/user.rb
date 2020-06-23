class User < ActiveRecord::Base
    has_secure_password
    has_many :user_histories
    has_many :quick_picks
end
