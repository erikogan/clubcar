require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_non_nulls
    user = User.new(:name => 'Fail me')
    assert !user.save

    uniq = [:login, :plain_password]

    uniq.each do |u|
      assert_equal ActiveRecord::Errors.default_error_messages[:blank], 
	user.errors.on(u)
    end
  end

  def test_unique_login
    user = User.new(:login => users(:average_joe).login,
		    :name => 'Another Joe',
		    :plain_password => 'joe2'
		    )
    assert !user.save
    assert_equal ActiveRecord::Errors.default_error_messages[:taken],
      user.errors.on(:login)
  end

  def test_password_on_create
    jane = User.new(:login => 'jane',
		    :name => 'Average Jane',
		    :plain_password => 'jane of the jungle'
		    )
    assert !jane.save
    assert_equal "should match confirmation", jane.errors.on(:plain_password)

    jane.plain_password_confirmation = 'jennifer of the jungle'

    assert !jane.save
    assert_equal "should match confirmation", jane.errors.on(:plain_password)

    jane.plain_password_confirmation = 'jane of the jungle'

    assert jane.save
  end

  def test_password_on_update
    joe = User.find_by_login(users(:average_joe).login)

    joe.plain_password = ''
    joe.plain_password_confirmation = ''

    assert joe.save

    new = 'better password'

    joe.plain_password_confirmation = new
    assert !joe.save
    assert_equal "should match confirmation", joe.errors.on(:plain_password)

    joe.plain_password = new
    joe.plain_password_confirmation = ''
    assert !joe.save
    assert_equal "should match confirmation", joe.errors.on(:plain_password)

    joe.plain_password_confirmation = new
    assert joe.save
  end

  def test_plain_password_updates_password_and_salt
    joe = User.find_by_login(users(:average_joe).login)
    old_p = joe.password
    old_s = joe.salt

    assert_not_nil old_p
    assert_not_nil old_s

    assert_not_equal '', old_p
    assert_not_equal '', old_s

    new = 'even better password'

    joe.plain_password = joe.plain_password_confirmation = new
    assert_valid joe
    assert_not_equal old_p, joe.password
    assert_not_equal old_s, joe.salt
  end

end

