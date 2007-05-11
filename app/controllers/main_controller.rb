class MainController < ApplicationController

  before_filter :find_user

  def index
    @moods = Mood.find_all_by_user_id(session[:user].id)
    @restaurants = Restaurant.find(:all, :order => :name)
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
