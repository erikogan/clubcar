require File.dirname(__FILE__) + '/../test_helper'

class TagTypeTest < Test::Unit::TestCase
  fixtures :tag_types

  def test_unique_name
    type = TagType.new(:name => tag_types(:genre).name)

    assert !type.save
    assert_equal ActiveRecord::Errors.default_error_messages[:taken],
      type.errors.on(:name)
  end
end
