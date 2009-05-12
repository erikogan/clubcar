class MainController < ApplicationController
  before_filter :find_user

  def index
    # @moods = Mood.find_all_by_user_id(session[:user].id, :order => 'moods.order, name')
    #@restaurants = Restaurant.find(:all, :order => :name)
    @logged_in = User.present.find(:all)
    # There should be only one
    @mood = @user.moods.active.first
    unless (@mood.nil?)
      @preferences = @mood.preferences.find(:all, :include => [:restaurant, :vote], :order => 'restaurants.name')
      @missing = Preference.missing_for(@mood)
      @preference_values = Vote.find(:all, :order => 'value DESC').collect do |v|
        [v.name, v, v.id]
      end
    end
  end


  def mail_warnings
    users = User.find_all_by_present(false, :include => :emails)
    text = "<pre>\n"
    users.each do |u|
      if u.emails
        email = ClubcarMailer.create_reactivate(u)
        ClubcarMailer.deliver(email)
        logger.info "QUEUE: #{u.emails[0].address}"
      end
    end
    
    #render(:text => text + "\n</pre>")
  end

  def inform_user
    @user = User.find(session[:user])
    email = ClubcarMailer.create_reactivate(@user) 
    render(:text => "<pre>" + email.encoded + "</pre>") 
  end

private

  def find_user
    # It's not so much "find" anymore
    @user = session[:user]
  end

end
