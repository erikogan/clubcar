class MainController < ApplicationController

  before_filter :find_user

  def index
    @moods = Mood.find_all_by_user_id(session[:user].id)
    @restaurants = Restaurant.find(:all, :order => :name)
  end


  def mail_warnings
    users = User.find_all_by_present(false)
    text = "<pre>\n"
    users.each do |u|
      email = ClubcarMailer.create_reactivate(u)
      ClubcarMailer.deliver(email)
      text += email.encoded + "\n--------------------------------------------------------------\n"
    end
    
    render(:text => text + "\n</pre>")
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
