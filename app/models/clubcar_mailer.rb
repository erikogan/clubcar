class ClubcarMailer < ActionMailer::Base

  FROM_ADDRESS = 'clubcar-admin@slackers.net'
  REPLY_ADDRESS = 'clubcar@slackers.net'

  def reactivate(user)
    @subject    = "[clubcar] Lunch today?#{magic_subject(user)}"
    @body       = {
      :user => user,
      :mood => user.moods.find_by_active(true)
    }
    @recipients = user.emails[0].address
    @from       = FROM_ADDRESS
    @sent_on    = Time.now
    @headers    = {'Reply-to' => REPLY_ADDRESS }
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
    @subject = "[clubcar] Forgotten Password?"
    @body = {:user => user, :magic => make_magic(user)}
    @recipients = user.emails[0].address
    @from       = FROM_ADDRESS
    @sent_on    = Time.now
    @headers    = {}  
  end

  def receive(email)
    (user,errors, magic) = confirm_subject(email)

    unless (user.nil? || errors.length > 0) 
      user.present = true;
      begin
        user.save!
        reply = self.class.create_reply_success(user, email, magic)
      rescue Exception => e
        reply = self.class.create_reply_error(user, email, magic, errors)
      end
    else
      user = User.new()
      reply = self.class.create_reply_error(user, email, magic, errors)
    end

    self.class.deliver(reply)
  end

  def reply_error(user, email, magic, errors)
    @subject    = "[clubcar] Error on activation#{magic}"
    @body       = {:errors => errors, :user => user}
    @recipients = email.from
    @from       = FROM_ADDRESS
    @sent_on    =  Time.now
    @headers    = {}
  end

  def reply_success(user, email, magic)
    @subject    = "[clubcar] Activation complete#{magic}"
    @body       = {:user => user}
    @recipients = email.from
    @from       = FROM_ADDRESS
    @sent_on    =  Time.now
    @headers    = {}
  end

private

  def magic_subject(user)
    return ' ' * 60 + "[[#{make_magic(user)}]]"
  end
  
  def make_magic(user)
    now = Time.now
    # 32 characters, at most 31 days, that's handy
    magic = Digest::MD5.hexdigest(user.salt + user.password)
    base64= ["#{user.login}!!#{Time.now.to_i}!!#{magic[now.day,1]}"].pack("m*").chomp
    return base64
  end

  def confirm_subject(email)
    email.subject =~ /(\s+\[\[(\w+={0,2})\]\])/
    token = $1
    return confirm_magic($2) << token
  end

public 

  def self.confirm_magic(base64)
    errors = []

    begin 
      if base64.nil?
        raise "Token missing"
      end

      (login,time,mini) = base64.unpack("m*")[0].split(/!!/)
      time = time.to_i

      if (time.nil? || mini.nil?) 
        raise "Corrupted token"
      end

      if (Time.now.to_i - time > 60 * 60 * 12)
        errors.push "Reply to an old warning"
      end

      user = User.find_by_login(login)
      magic = Digest::MD5.hexdigest(user.salt + user.password)

      # 32 characters, at most 31 days, that's handy
      unless (magic[Time.at(time).day,1] == mini) 
        errors.push "Bogus magic number"
      end
    rescue Exception => e
      errors.push e.message
      #errors.push *e.backtrace
    end

    return user, errors
  end
end
