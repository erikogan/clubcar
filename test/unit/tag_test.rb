require File.dirname(__FILE__) + '/../test_helper'

require 'pp'

class TagTest < Test::Unit::TestCase
  fixtures :tag_types, :tags
  
  def test_unique_canonical
    # also tests name=
    tag = Tag.new(:name => tags(:yummy).name + "!!@",
                  :type_id => tags(:yummy).type_id)
    assert !tag.save
    assert_equal "has already been taken", tag.errors.on(:canonical)
  end

  def test_find_by_name
    # also test ==
    tag = Tag.find_by_name('YuMmy!!!$#')
    assert tag == tags(:yummy)
  end

  def test_validate_canonical
    tag = Tag.find_by_name("Yummy!")
    assert_raise(RuntimeError) { tag.name = "Not so yummy" }
    
    tag.name = "YuMmY! ! ? !"
    assert tag.save
  end

  def test_fetch_tags
    tags = Tag.fetch(Tag.tag_type, "oh, captain, my captain!", "foobar")
    assert_equal 4, tags.length
    assert_equal 6, Tag.count
    t = Tag.find_by_name("fOoBaR")
    assert_equal t, tags[3]
  end
end
