require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  setup do
    @household = households(:smith)
  end

  test "valid with name only" do
    category = Category.new(name: "Utilities", household: @household)
    assert category.valid?
  end

  test "valid with name and budget" do
    category = Category.new(name: "Utilities", monthly_budget: 300, household: @household)
    assert category.valid?
  end

  test "invalid without household" do
    category = Category.new(name: "Utilities")
    assert_not category.valid?
  end

  test "invalid with zero budget" do
    category = Category.new(name: "Utilities", monthly_budget: 0, household: @household)
    assert_not category.valid?
    assert_includes category.errors[:monthly_budget], "must be greater than 0"
  end

  test "invalid with negative budget" do
    category = Category.new(name: "Utilities", monthly_budget: -100, household: @household)
    assert_not category.valid?
    assert_includes category.errors[:monthly_budget], "must be greater than 0"
  end

  test "valid with nil budget" do
    category = Category.new(name: "Utilities", monthly_budget: nil, household: @household)
    assert category.valid?
  end
end
