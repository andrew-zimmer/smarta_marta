class User < ActiveRecord::Base
    has_secure_password
    has_many :user_chronicles
    has_many :quick_picks

    validates_presence_of :first_name, :last_name, :email
    validates_uniqueness_of :email
end
