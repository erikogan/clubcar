require 'digest/md5'

class User < ActiveRecord::Base
  has_many :moods, :dependent => :destroy, :order => 'moods.order, moods.name'
  # I don't think this relationship is actually meaningful 
  # has_many :preferences, :through => :moods

  # for now, 1-1, eventually 1-many
  has_many :emails, :dependent => :destroy

  validates_presence_of :login
  validates_uniqueness_of :login

  attr_protected :admin
  attr_accessor :plain_password_confirmation
  
  ## this also fails when the fields are both nil, which is
  ## counter-intuitive, and undesirable in the update case (when you
  ## might not want to change their password)
  # validates_confirmation_of :plain_password
  def validate_on_create 
    valid = true;
    if @plain_password != @plain_password_confirmation
      errors.add(:plain_password,  "should match confirmation")
      valid = false; 
    elsif @plain_password.blank?
      errors.add(:plain_password, "can't be blank")
      valid = false
    end
    valid
  end

  def validate_on_update
    valid = true;
    if (!(@plain_password.blank? && @plain_password_confirmation.blank?) && @plain_password != @plain_password_confirmation)
      errors.add(:plain_password, "should match confirmation")
      valid = false; 
    end
    valid
  end

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

  def self.authenticate(user,password) 
    user = self.find_by_login(user)
    if user && user.password != encrypted_password(password, user.salt)
      user = nil
    end
    user
  end

  # plain_password is a virutal attribute
  def plain_password 
    @plain_password
  end

  def plain_password=(pwd)
    # Don't encrypt nil
    if !pwd.blank?
      @plain_password = pwd
      create_new_salt
      self.password = User.encrypted_password(self.plain_password, self.salt)
    end
  end

  def is_admin?
    return self.valid? && self.admin
  end

  ####################################################################
  private

  def self.encrypted_password(password,salt)
    Digest::MD5.hexdigest(salt + password)
  end

  def create_new_salt 
    # Might as well use the same digest algorithm
    self.salt = User.encrypted_password(self.object_id.to_s, rand.to_s)
  end
end
