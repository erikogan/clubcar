class UsersController < ApplicationController
  # GET /users
  # GET /users.xml

  before_filter :clarify_title
  before_filter :admin_access, :except => [:index]

  skip_before_filter :authorize, :only => [:login, :logout]
  # This is a Bad Idea(tm). We should go back to just storing the ID, but
  # that's more invasive
  after_filter :update_session, :only => [:create, :update, :delete, 
    :activate, :deactivate ]

  def index
    @users = User.find(:all, :order => :login)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @users.to_xml }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @user.to_xml }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1;edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to user_url(@user) }
        format.xml  { head :created, :location => user_url(@user) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to user_url(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.xml  { head :ok }
    end
  end

  # POST /users/1;activate
  def activate
    do_activation(true)
  end

  # POST /users/1;deactivate
  def deactivate
    do_activation(false)
  end

  def login
    # CGI::Session doesn't act remotely like a hash
    # session.delete(:user)
    session[:user] = nil
    if request.post?
      user = User.authenticate(params[:login], params[:plain_password])

      if user
        session[:user] = user
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :action => :index })
      else
        flash[:notice] = "Invalid username/password"
      end
    end
  end

  def logout
    # CGI::Session doesn't act remotely like a hash
    # session.delete(:user)
    session[:user] = nil
  end

private

  def clarify_title
  end

  def do_activation(value)
    @user = User.find(params[:id])
    @user.present = value;
    @user.save!

    if (request.xhr?) 
      render :partial => '/users/presence_link', :object => @user
    else 
      redirect_to(url_for(:action => :show, :id => @user.id)) 
    end
  end

  # Still a Bad IDEA(tm)
  def update_session
    unless @user.nil? || @user.id != session[:user].id
      session[:user] = @user
    end
  end

end
