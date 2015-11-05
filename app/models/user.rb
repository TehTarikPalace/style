class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
        #  :registerable, :recoverable,
          :rememberable, :trackable, :validatable
  has_many :user_credentials

  after_initialize :default_values

  def default_values
    self.admin ||= false
  end
end
