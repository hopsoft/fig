require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'hopsoft', 'string')

class StringTest < Test::Unit::TestCase

  def test_interpolate_with_string
    orig = "Hello! My name is ?"
    interpolated = orig.interpolate("Nathan Hopkins")
    expected = "Hello! My name is Nathan Hopkins"
    assert_not_equal orig, interpolated, "Should not have mutated in place"
    assert_equal expected, interpolated

    interpolated = orig.interpolate("Nathan Hopkins", true)
    assert_equal orig, interpolated, "Should have mutated in place"
    assert_equal expected, interpolated
  end

  def test_interpolate_with_symbol
    orig = "Hello! My name is ?"
    interpolated = orig.interpolate(:Nathan)
    expected = "Hello! My name is Nathan"
    assert_not_equal orig, interpolated, "Should not have mutated in place"
    assert_equal expected, interpolated

    interpolated = orig.interpolate(:Nathan, true)
    assert_equal orig, interpolated, "Should have mutated in place"
    assert_equal expected, interpolated
  end

  def test_interpolate_with_array
    orig = "Hello! My first name is ? and my last name is ?"
    interpolated = orig.interpolate(["Nathan", :Hopkins])
    expected = "Hello! My first name is Nathan and my last name is Hopkins"
    assert_not_equal orig, interpolated, "Should not have mutated in place"
    assert_equal expected, interpolated

    interpolated = orig.interpolate(["Nathan", :Hopkins], true)
    assert_equal orig, interpolated, "Should have mutated in place"
    assert_equal expected, interpolated
  end

  def test_interpolate_with_hash
    orig = 'Hello! My first name is {first_name} and my last name is {last_name}'
    interpolated = orig.interpolate(:first_name => "Nathan", :last_name => :Hopkins)
    expected = "Hello! My first name is Nathan and my last name is Hopkins"
    assert_not_equal orig, interpolated, "Should not have mutated in place"
    assert_equal expected, interpolated

    interpolated = orig.interpolate({:first_name => "Nathan", :last_name => :Hopkins}, true)
    assert_equal orig, interpolated, "Should have mutated in place"
    assert_equal expected, interpolated
  end

end
