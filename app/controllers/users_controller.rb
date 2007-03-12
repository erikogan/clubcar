class UsersController < ApplicationController
  # GET /users
  # GET /users.xml

  before_filter :clarify_title

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
    @clarifyTitle = ' ' + @user.name

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @user.to_xml }
    end
  end

  # GET /users/new
  def new
    @user = User.new
    @clarifyTitle = ''
  end

  # GET /users/1;edit
  def edit
    @user = User.find(params[:id])
    @clarifyTitle = ' ' + @user.name
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @clarifyTitle = ' ' + @user.name

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
    @clarifyTitle = ' ' + @user.name

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
    @clarifyTitle = ' ' + @user.name
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.xml  { head :ok }
    end
  end

  def login
    session[:user_id] = nil
    session[:real_id] = nil
    if request.post?
		  
      user = User.authenticate(params[:login], params[:plain_password])
      if user
	session[:user_id] = user.id
	session[:real_id] = user.id
	uri = session[:original_uri]
	session[:original_uri] = nil
	redirect_to(uri || { :action => :index })
      else
	flash[:notice] = "Invalid username/password"
      end
    end
  end

  def logout
    session[:user_id] = nil
    session[:real_id] = nil
  end

private

  def clarify_title
    @clarifyTitle = 's'
  end
end
