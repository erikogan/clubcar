require File.dirname(__FILE__) + '/../test_helper'

class ClubcarMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  def test_reactivate
    @expected.subject = 'ClubcarMailer#reactivate'
    @expected.body    = read_fixture('reactivate')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ClubcarMailer.create_reactivate(@expected.date).encoded
  end

  def test_decision
    @expected.subject = 'ClubcarMailer#decision'
    @expected.body    = read_fixture('decision')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ClubcarMailer.create_decision(@expected.date).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/clubcar_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
