class UserCredential < ActiveRecord::Base
  belongs_to :user
  belongs_to :studio_connection
end
