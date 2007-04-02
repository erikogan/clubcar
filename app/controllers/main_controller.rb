class MainController < ApplicationController

  before_filter :find_user

  def index
    @moods = Mood.find_all_by_user_id(session[:user].id)
    @restaurants = Restaurant.find(:all, :order => :name)
  end

private

  def find_user
    @user_id = session[:user_id]
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
