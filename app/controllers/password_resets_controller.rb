class PasswordResetsController < ApplicationController
  skip_before_filter :authorize
  
  # GET /password_resets
  # GET /password_resets.xml
  def index
    redirect_to(new_password_reset_path) 
  end

  # GET /password_resets/1
  # GET /password_resets/1.xml
  def show
    redirect_to(new_password_reset_path) 
  end

  # GET /password_resets/new
  # GET /password_resets/new.xml
  def new
    respond_to do |format|
      format.html
      # format.xml  { render :xml => @password_reset }
    end
  end

  # GET /password_resets/1/edit
  def edit
    @user, @errors = ClubcarMailer.confirm_magic(params[:id])
    respond_to do |format|
      if (@errors.empty?)
        format.html
      else
        flash.now[:error] = @errors
        format.html { render :action => "new" }
        #format.xml { render :xml => @errors, :status => :bogus_magic }
      end
    end
  end

  # POST /password_resets
  # POST /password_resets.xml
  def create
    @user = User.find_by_login_or_email(params[:password_reset])    
    respond_to do |format|
      begin
        throw Exception.new("Can't find user!") unless @user
        email = ClubcarMailer.create_forgotten_password(@user)
        ClubcarMailer.deliver(email)
        flash[:notice] = 'Password reset request has been sent. Check your inbox.'
        format.html { redirect_to(new_password_reset_path) }
        format.xml  { render :xml => email, :status => :created}
      rescue
        flash.now[:error] = $!.message
        format.html { render :action => "new" }
        format.xml  { render :xml => $!, :status => :email_failed }
      end
    end
  end

  # PUT /password_resets/1
  # PUT /password_resets/1.xml
  def update
    @user, @errors = ClubcarMailer.confirm_magic(params[:id])
   
    respond_to do |format|
      if @errors.empty? && @user.update_attributes(params[:user]) && @user.save
        flash[:notice] = 'Your Password has been changed.'
        format.html { redirect_to root_url }
        format.xml  { head :ok }
      else
        if (!@user)
          @user = User.new
          @errors.each do |e|
            @user.errors.add :perishable_token
          end
        end
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /password_resets/1
  # DELETE /password_resets/1.xml
  def destroy
    redirect_to(new_password_reset_path) 
  end
end
