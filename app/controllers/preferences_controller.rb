class PreferencesController < ApplicationController

  before_filter :find_user_mood
  before_filter :get_preference_values, :only => [:edit, :change]

  # GET /preferences
  # GET /preferences.xml
  def index
    @preferences = Preference.find_all_by_mood_id(@mood_id, :include => :restaurant)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @preferences.to_xml }
    end
  end

  # GET /preferences/1
  # GET /preferences/1.xml
  def show
    @preference = Preference.find(params[:id], :include => :restaurant)

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @preference.to_xml }
    end
  end

  # GET /preferences/new
  def new
    @preference = Preference.new
  end

  # GET /preferences/1;edit
  def edit
    @preference = Preference.find(params[:id])
  end

  # POST /preferences
  # POST /preferences.xml
  def create
    @preference = Preference.new(params[:preference])

    respond_to do |format|
      if @preference.save
        flash[:notice] = 'Preference was successfully created.'
        format.html { redirect_to preference_url(@preference) }
        format.xml  { head :created, :location => preference_url(@preference) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @preference.errors.to_xml }
      end
    end
  end

  # PUT /preferences/1
  # PUT /preferences/1.xml
  def update
    @preference = Preference.find(params[:id])

    respond_to do |format|
      if @preference.update_attributes(params[:preference])
        flash[:notice] = 'Preference was successfully updated.'
        format.html { redirect_to preference_url(@preference) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @preference.errors.to_xml }
      end
    end
  end

  # DELETE /preferences/1
  # DELETE /preferences/1.xml
  def destroy
    @preference = Preference.find(params[:id])
    @preference.destroy

    respond_to do |format|
      format.html { redirect_to preferences_url }
      format.xml  { head :ok }
    end
  end

  # GET /preferences;change
  # GET /preferences.xml;change
  def change 
    @preferences = Preference.find_all_by_mood_id(@mood_id, :include => :restaurant, :order => 'restaurants.name')
    @missing = Preference.missing_for(@mood)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @preferences.to_xml }
    end
  end

  # POST /preferences;save
  def save
    updated = false;

    if params.has_key?(:new) 
      # Turn params[new] into an array of hashes (from a hash of hashes)
      # (I suspect there's an easier way to do this)
      create = Array.new
      params[:new].keys.sort_by {|a| a.to_i}.collect do |k|
	create.push(params[:new][k])
      end
      updated = true if Preference.create(create)
	
    end
    
    if params.has_key?(:preference)
      updated = true if
	Preference.update(params[:preference].keys,params[:preference].values)
    end

      if updated
        flash[:notice] = 'Preferences successfully updated.'
      end

    respond_to do |format|
        format.html { redirect_to change_preferences_url(@user_id,@mood_id) }
        format.xml  { head :ok }
    end
  end

private

  # I should abstract find_user, and share that with MoodsController
  def find_user_mood 
    @user_id = params[:user_id]
    @mood_id = params[:mood_id]
    # ActiveRecord .find methods throw an exception when they fail, this
    # needs to be reworked
    begin
      unless @user_id.blank?
	@user = User.find(@user_id)
      end
    rescue
      redirect_to users_url
    end

    begin
      unless @mood_id.blank?
	@mood = Mood.find(@mood_id)
	return
      end
    rescue
      # The return handled the base case, everything else is redirected
    end

    redirect_to moods_url(@user)
  end

  def get_preference_values
    @preference_values =  Preference.value_order.collect do |v|
      [v.to_s.humanize, v, Preference.value(v) ]
    end
  end
end
