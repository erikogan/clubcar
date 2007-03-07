class MoodsController < ApplicationController

  before_filter :find_user

  # GET /moods
  # GET /moods.xml
  def index
    # @moods = Mood.find_by_user_id(session[:user_id])
    @moods = @user.moods

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @moods.to_xml }
    end
  end

  # GET /moods/1
  # GET /moods/1.xml
  def show
    # @mood = Mood.find(params[:id])
    @mood = @user.moods.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @mood.to_xml }
    end
  end

  # GET /moods/new
  def new
    @mood = Mood.new
  end

  # GET /moods/1;edit
  def edit
    # @mood = Mood.find(params[:id])
    @mood = @user.moods.find(params[:id])
  end

  # POST /moods
  # POST /moods.xml
  def create
    @mood = Mood.new(params[:mood])
    
    respond_to do |format|
      # if @mood.save
      if @user.moods << @mood 
        flash[:notice] = 'Mood was successfully created.'
        format.html { redirect_to mood_url(@mood) }
        format.xml  { head :created, :location => mood_url(@mood) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mood.errors.to_xml }
      end
    end
  end

  # PUT /moods/1
  # PUT /moods/1.xml
  def update
    # @mood = Mood.find(params[:id])
    @mood = @user.moods.find(params[:id])

    respond_to do |format|
      if @mood.update_attributes(params[:mood])
        flash[:notice] = 'Mood was successfully updated.'
        format.html { redirect_to mood_url(@mood) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mood.errors.to_xml }
      end
    end
  end

  # DELETE /moods/1
  # DELETE /moods/1.xml
  def destroy
    # @mood = Mood.find(params[:id])
    # why does only this one need the .to_i ?
    mood = @user.moods.find(params[:id].to_i)
    mood.destroy
    @user.moods.delete(mood)

    respond_to do |format|
      format.html { redirect_to moods_url }
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
end
