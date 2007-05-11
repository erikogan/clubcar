class ClubcarMailer < ActionMailer::Base

FROM_ADDRESS = 'erik@cloudshield.com'

  def reactivate(user)
    @subject    = '[clubcar] Lunch today?'
    @body       = {:user => user}
    @recipients = user.email.email
    @from       = FROM_ADDRESS
    @sent_on    = Time.nowq
    @headers    = {}
  end

  def decision(choices)
    users = User.find_all_by_present(false);

    raise "No users are present!" if users.empty?

    @subject    = '[clubcar] Today\'s Suggestions'
    @body       = {:choices => choices }
    @recipients = users.map { |u| u.email.email }
    @from       = FROM_ADDRESS
    @sent_on    = Time.now
    @headers    = {}
  end
end
