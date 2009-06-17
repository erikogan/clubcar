require "lib/reverse_md5"

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # (understandably) bad things happen thus configured
    # c.crypted_password_field :password
    # I LOVE Authlogic for this
    c.transition_from_crypto_providers Authlogic::CryptoProviders::ReverseMD5
    # May want to add this later
    # c.validations_scope = :group_id
    c.perishable_token_valid_for 3.hours
  end
  
  has_many :moods, :dependent => :destroy, :order => 'moods.order, moods.name'
  # I don't think this relationship is actually meaningful 
  # has_many :preferences, :through => :moods

  # for now, 1-1, eventually 1-many
  has_many :emails, :dependent => :destroy

  named_scope :present, :conditions => ['present = true'], :order => 'name'

  acts_as_tagger

  attr_protected :admin

  def self.find_by_login_or_email(params) 
    loe = params[:login_or_email]
    
    if (params[:login] || loe)
      user = User.find_by_login(params[:login] || loe)
      return user if user
    end
    
    if (params[:email] || loe) 
      user = Email.find_by_address(params[:email] || loe).user
      return user if user
    end
    
    return nil
  end

  def is_admin?
    return self.valid? && self.admin
  end
end
