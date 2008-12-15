class PreferencesController < ApplicationController

  before_filter :admin_access
  before_filter :find_user_mood
  before_filter :get_preference_values, :only => [:edit, :change]

  # GET /preferences
  # GET /preferences.xml
  def index
    @preferences = @mood.preferences.find(:all, :include => [:restaurant, :vote], :order => 'restaurants.name')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @preferences.to_xml }
    end
  end

  # GET /preferences/1
  # GET /preferences/1.xml
  def show
    @preference = @mood.preferences.find(params[:id], :include => [:restaurant, :vote])

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
    @preference = @mood.preferences.find(params[:id])
  end

  # POST /preferences
  # POST /preferences.xml
  def create
    @preference = Preference.new(params[:preference])

    respond_to do |format|
      if @preference.save
        flash[:notice] = 'Preference was successfully created.'
        format.html { redirect_to user_mood_preference_url(@user,@mood,@preference) }
        format.xml  { head :created, :location => user_mood_preference_url(@user,@mood,@preference) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @preference.errors.to_xml }
      end
    end
  end

  # PUT /preferences/1
  # PUT /preferences/1.xml
  def update
    @preference = @mood.preferences.find(params[:id])

    respond_to do |format|
      if @preference.update_attributes(params[:preference])
        flash[:notice] = 'Preference was successfully updated.'
        format.html { redirect_to user_mood_preference_url(@user,@mood,@preference) }
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
    @preference = @mood.preferences.find(params[:id])
    @preference.destroy

    respond_to do |format|
      format.html { redirect_to user_mood_preferences_url(@user,@mood) }
      format.xml  { head :ok }
    end
  end

  # GET /preferences;change
  # GET /preferences.xml;change
  def change 
    @preferences = @mood.preferences.find(:all, :include => [:restaurant, :vote], :order => 'restaurants.name')
    @missing = Preference.missing_for(@mood)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @preferences.to_xml }
    end
  end

  # POST /preferences;save
  def save
    updated = false;
    
    # I think the easiest thing to do is to make this empty
    @missing = Array.new

    # [xxx erik] While the Preference.{create,update} taking two arrays
    # is handy, it doesn't keep @mood up to date, and since we may be
    # rendering again with error messages, that's a UX nightmare
    fromParams = Array.new

    if (params.has_key?(:new))
      params[:new].each { |k, v| fromParams.push(Preference.new(v)) }
      updated = true
    end

    begin
      Preference.transaction do
        if (params.has_key?(:preference))
          # this is a bit trickier, I think this is the most efficient
          # route (assuming most of the preferences are in the params)
          # also moving this insde the transaction, in case things get
          # saved (which they shouldn't)
          @mood.preferences.each do |p|
            # WTF? No "has_key"
            #if (params[:preference].has_key(p.id.to_s))
            unless(params[:preference][p.id.to_s].nil?)
              p.vote_id = params[:preference][p.id.to_s][:vote_id]
              # fromParams.push(p)
            end
            updated = true
          end
        end
        
        # This definitely causes database inserts
        @mood.preferences << fromParams

        @mood.save!
        #raise @mood.valid? + @mood.errors.full_messages.join("<br/>")

        # I think this needs to be explicit, since we didn't change
        # these via the normal interfaces
        @mood.preferences.each {|p| p.save! }
      end
    rescue Exception => e
      @preferences = @mood.preferences.sort_by { |p| p.restaurant.name }
      # Only do this if you need to
      get_preference_values
      respond_to do |format|
        # flash[:notice] = e.message
        format.html { render :action => "change" }
        format.xml { render :xml => @mood.errors.to_xml }
      end
    else
      respond_to do |format|
        format.js {
          @preferences = @mood.preferences.find(:all, :include => [:restaurant, :vote], :order => 'restaurants.name')
          @missing = Preference.missing_for(@mood)
          get_preference_values
        }
        if updated
          flash[:notice] = 'Preferences successfully updated.'
        end
        format.html { redirect_to change_user_mood_preferences_url(@user,@mood) }
        format.xml  { head :ok }
      end
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
        @mood = @user.moods.find(@mood_id)
        return
      end
    rescue
      # The return handled the base case, everything else is redirected
    end

    redirect_to user_moods_url(@user)
  end

  def get_preference_values
    @preference_values = Vote.find(:all, :order => 'value DESC').collect do |v|
      [v.name, v, v.id]
    end
  end
end
