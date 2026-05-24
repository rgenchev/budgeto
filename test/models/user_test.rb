require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "initials uses first letter of first and last name" do
    user = users(:alice)
    assert_equal "AS", user.initials
  end

  test "initials uses only first name initial when last name is blank" do
    user = users(:alice)
    user.last_name = nil
    assert_equal "A", user.initials
  end

  test "initials falls back to first letter of email when no name is set" do
    user = User.new(email_address: "zebra@example.com", household: households(:smith))
    assert_equal "Z", user.initials
  end

  test "display_name returns full name when both names are set" do
    assert_equal "Alice Smith", users(:alice).display_name
  end

  test "display_name falls back to email when no name is set" do
    user = User.new(email_address: "anon@example.com", household: households(:smith))
    assert_equal "anon@example.com", user.display_name
  end

  test "first and last name are stripped on save" do
    user = users(:alice)
    user.update!(first_name: "  Alice  ", last_name: "  Smith  ")
    assert_equal "Alice", user.first_name
    assert_equal "Smith", user.last_name
  end

  test "invalid without household" do
    user = User.new(email_address: "test@example.com", password: "password")
    assert_not user.valid?
    assert user.errors[:household].any?
  end
end
