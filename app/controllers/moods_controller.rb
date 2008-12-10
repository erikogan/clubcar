class MoodsController < ApplicationController

  before_filter :admin_access
  before_filter :find_user
  before_filter :clarify_title

  # GET /users/42/moods
  # GET /users/42/moods.xml
  def index
    @moods = @user.moods.sort do |a,b| 
      ao = a.order
      bo = b.order

      # This is not clearer than with explicit returns, however it
      # doesn't throw an excpetion, either. (I need to figure out
      # "returning" from a block)
      if !( ao.nil? || bo.nil?)
        ao <=> bo || a.name.casecmp(b.name)
      elsif ao.nil? && bo.nil?
        a.name.casecmp(b.name)
      elsif ao.nil?
        -1
      else
        1
      end
    end

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @moods.to_xml }
    end
  end

  # GET /users/42/moods/1
  # GET /users/42/moods/1.xml
  def show
    # @mood = Mood.find(params[:id])
    @mood = @user.moods.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @mood.to_xml }
    end
  end

  # GET /users/42/moods/new
  def new
    @mood = Mood.new
  end

  # GET /users/42/moods/1;edit
  def edit
    # @mood = Mood.find(params[:id])
    @mood = @user.moods.find(params[:id])
  end

  # POST /users/42/moods
  # POST /users/42/moods.xml
  def create
    activate = false;
    if (params[:mood][:active] == true)
      params[:mood].delete(:active)
      activate = true
    end
    
    @mood = Mood.new(params[:mood])
    respond_to do |format|
      Mood.transaction do
        # if @mood.save
        if @user.moods << @mood && (!activate || @mood.activate)
          flash[:notice] = 'Mood was successfully created.'
          format.html { redirect_to change_user_mood_preferences_url(@user, @mood) }
          format.xml  { head :created, :location => user_mood_url(@user, @mood) }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @mood.errors.to_xml }
        end
      end
    end
  end

  # PUT /users/42/moods/1
  # PUT /users/42/moods/1.xml
  def update
    activate = false;
    if (params[:mood][:active] == true)
      params[:mood].delete(:active)
      activate = true
    end

    @mood = @user.moods.find(params[:id])

    respond_to do |format|
      Mood.transaction do
        if @mood.update_attributes(params[:mood]) && (!activate || @mood.activate)
          flash[:notice] = 'Mood was successfully updated.'
          format.html { redirect_to user_mood_url(@user, @mood) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @mood.errors.to_xml }
        end
      end
    end
  end

  # DELETE /users/42/moods/1
  # DELETE /users/42/moods/1.xml
  def destroy
    # @mood = Mood.find(params[:id])
    # why does only this one need the .to_i ?
    mood = @user.moods.find(params[:id].to_i)
    mood.destroy
    @user.moods.delete(mood)

    respond_to do |format|
      format.html { redirect_to user_moods_url(@user) }
      format.xml  { head :ok }
    end
  end

  # POST /users/42/moods/1;activate
  def activate
    @mood = @user.moods.find(params[:id])

    begin
      @mood.activate
    rescue Exception => e
      flash[:notice] = "Failed to activate #{@mood.name}: #{$!} (#{e.message})"
    end
    respond_to do |format|
      format.html { redirect_to user_mood_url(@user,@mood) }
      format.xml  { render :xml => @mood.errors.to_xml }
      format.js  {}
    end
  end

  # POST /users/42/moods/1;copy
  def copy
    mood = @user.moods.find(params[:id])
    @mood = Mood.new(mood.attributes)

    # I'm pretty sure this is covered by the attr_protect directive, but
    # lets be sure (tested, it is)
    # @mood.active = false;
    @mood.name = "#{@mood.name} (copy)"

    mood.preferences.collect { |p| @mood.preferences << Preference.new(p.attributes) }

    unless (@mood.save) 
      flash[:notice] = "Can't save mood! #{@mood.errors}"
    end
    
    redirect_to edit_user_mood_url(@user,@mood)
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
      logger.debug("Exception: #{$!.inspect}")
    end

    redirect_to users_url
  end

  def clarify_title
  end
end
