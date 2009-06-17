class ClubcarMailer < ActionMailer::Base

  FROM_ADDRESS = 'clubcar-admin@slackers.net'
  ACTIVATION_ADDRESS = 'clubcar@slackers.net'

  def reactivate(user)
    @subject    = "[clubcar] Lunch today?#{magic_subject(user)}"
    @body       = {
      :user => user,
      :mood => user.moods.find_by_active(true)
    }
    @recipients = user.emails[0].address
    @from       = FROM_ADDRESS
    @sent_on    = Time.now
    @headers    = {'Reply-to' => ACTIVATION_ADDRESS }
  end

  def decision(choices)
    users = User.find_all_by_present(true);

    raise "No users are present!" if users.empty?

    @subject    = '[clubcar] Today\'s Suggestions'
    @body       = {:choices => choices }
    @recipients = users.map { |u| u.emails[0].address }
    @from       = FROM_ADDRESS
    @sent_on    = Time.now
    @headers    = {}
  end

  def forgotten_password(user)
    user.reset_perishable_token!
    @subject = "[clubcar] Forgotten Password?"
    @body = {:user => user, :magic => user.perishable_token}
    @recipients = user.emails[0].address
    @from       = FROM_ADDRESS
    @sent_on    = Time.now
    @headers    = {}  
  end

  def receive(email)
    (user, errors, token) = confirm_subject(email)

    unless (user.nil? || errors.length > 0) 
      user.present = true;
      begin
        user.save!
        reply = self.class.create_reply_success(user, email, token)
      rescue Exception => e
        reply = self.class.create_reply_error(user, email, token, errors)
      end
    else
      user = User.new()
      reply = self.class.create_reply_error(user, email, token, errors)
    end

    self.class.deliver(reply)
  end

  def reply_error(user, email, token, errors)
    @subject    = "[clubcar] Error on activation#{token}"
    @body       = {:errors => errors, :user => user}
    @recipients = email.from
    @from       = FROM_ADDRESS
    @sent_on    =  Time.now
    @headers    = {}
  end

  def reply_success(user, email, token)
    @subject    = "[clubcar] Activation complete#{token}"
    @body       = {:user => user}
    @recipients = email.from
    @from       = FROM_ADDRESS
    @sent_on    =  Time.now
    @headers    = {}
  end

private

  def magic_subject(user)
    user.reset_perishable_token!
    return ' ' * 60 + "[[#{user.perishable_token}]]"
  end
  
  def confirm_subject(email)
    email.subject =~ /(\s+\[\[(\w+={0,2})\]\])/
    token = $1
    return self.class.confirm_magic($2) << token
  end

public 

  def self.confirm_magic(token)
    errors = []
    
    if token
      user = User.find_using_perishable_token(token)
      unless user
        errors << "Invalid Token"
      end
    else
      errors << "Missing Token"
    end
    
    return user, errors
  end
end
