class UsersController < ApplicationController
  before_action :authenticate_user!, :only => [:credentials, :update_credentials]

  def credentials
    #you can only see you own
    if params[:user_id] == current_user.id.to_s then
      @connections = StudioConnection.all
      @credentials = current_user.user_credentials

      respond_to do |format|
        format.html
      end
    else
      render :file => "public/403.html", :status => :forbidden
    end
  end

  def update_credentials

    #you can only update your own
    if params[:user_id] == current_user.id.to_s then
      #update or create new credentials
      params[:credentials].each_pair do |key, credential|

        Rails.logger.info "credential = #{credential}"
        current_credential = current_user.user_credentials.select{ |x| x.studio_connection_id.to_s == credential[:id]}.first
        if current_credential.nil? then
          current_credential = current_user.user_credentials.new({
            :studio_connection_id => credential["id"],
            :username => credential["username"],
            :password => credential["password"]
          })
        else
          current_credential.assign_attributes({
              :username => credential["username"],
              :password => credential["password"]
          })
        end
        current_credential.save!
      end

      respond_to do |format|
        format.html{
          flash[:notice] = "Credentials updated"
          redirect_to user_credentials_path(current_user)
        }
      end
    else
      render :file => "public/403.html", :status => :forbidden
    end
  end

  def new
    respond_to do |format|
      format.template {
          render :template => 'users/form.template', :locals => { :user => User.new }
      }
    end
  end

  #update admins list
  # POST   /settings/admins
  def update_admins
    # requirement, user must login first before can change into admins
    #check if user exists. If everything tip top, the proceed to update userlist
    if User.where(:username => params[:username]).count != params[:username].count then
      flash[:alert] = "Some username do not exists"
      redirect_to :back
    else
      #remove users that not in the list
      non_admin = User.where(:admin => true).where.not(:username => params[:username])
      non_admin.each{|x| x.update_attribute(:admin, false)}

      #set all as admins
      User.where(:username => params[:username]).each{|x| x.update_attribute(:admin, true)}

      flash[:notice] = "Admin list updated"
      redirect_to :back
    end
  end
end
