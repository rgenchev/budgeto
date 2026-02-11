require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "valid with name only" do
    category = Category.new(name: "Test")
    assert category.valid?
  end

  test "valid with name and budget" do
    category = Category.new(name: "Test", monthly_budget: 300)
    assert category.valid?
  end

  test "invalid with zero budget" do
    category = Category.new(name: "Test", monthly_budget: 0)
    assert_not category.valid?
    assert_includes category.errors[:monthly_budget], "must be greater than 0"
  end

  test "invalid with negative budget" do
    category = Category.new(name: "Test", monthly_budget: -100)
    assert_not category.valid?
    assert_includes category.errors[:monthly_budget], "must be greater than 0"
  end

  test "valid with nil budget" do
    category = Category.new(name: "Test", monthly_budget: nil)
    assert category.valid?
  end
end
