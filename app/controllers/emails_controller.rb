class EmailsController < ApplicationController
  before_filter :admin_access
  before_filter :find_user

  # GET /emails
  # GET /emails.xml
  def index
    @emails = @user.emails.sort { |a,b| a.address <=> b.address }

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @emails.to_xml }
    end
  end

  # GET /emails/1
  # GET /emails/1.xml
  def show
    @email = @user.emails.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @email.to_xml }
    end
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1;edit
  def edit
    @email = @user.emails.find(params[:id])
  end

  # POST /emails
  # POST /emails.xml
  def create
    @email = Email.new(params[:email])

    respond_to do |format|
      # if @email.save
      if @user.emails << @email 
        flash[:notice] = 'Email was successfully created.'
        format.html { redirect_to email_url(@user, @email) }
        format.xml  { head :created, :location => email_url(@user, @email) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email.errors.to_xml }
      end
    end
  end

  # PUT /emails/1
  # PUT /emails/1.xml
  def update
    @email = @user.emails.find(params[:id])

    respond_to do |format|
      if @email.update_attributes(params[:email])
        flash[:notice] = 'Email was successfully updated.'
        format.html { redirect_to email_url(@user,@email) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @email.errors.to_xml }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.xml
  def destroy
    @email = @user.emails.find(params[:id])
    @email.destroy

    respond_to do |format|
      format.html { redirect_to emails_url }
      format.xml  { head :ok }
    end
  end

private

  def find_user
    @user_id = params[:user_id]
    # ActiveRecord .find methods throw an exception when they fail, this
    # needs to be reworked
    begin
      unless @user_id.blank?
	@user = User.find(@user_id)
	return
      end
    rescue
      # The return handled the base case, everything else is redirected
    end

    redirect_to users_url
  end

  def clarify_title
    @clarifyTitle = 's'
  end


end
