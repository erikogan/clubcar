class ClubcarMailer < ActionMailer::Base

FROM_ADDRESS = 'clubcar@eogan.usr.cloudshield.com'

  def reactivate(user)
    @subject    = '[clubcar] Lunch today?'
    @body       = {:user => user}
    @recipients = user.emails.email
    @from       = FROM_ADDRESS
    @sent_on    = Time.now
    @headers    = {}
  end

  def decision(choices)
    users = User.find_all_by_present(true);

    raise "No users are present!" if users.empty?

    @subject    = '[clubcar] Today\'s Suggestions'
    @body       = {:choices => choices }
    @recipients = users.map { |u| u.emails.email }
    @from       = FROM_ADDRESS
    @sent_on    = Time.now
    @headers    = {}
  end
end
