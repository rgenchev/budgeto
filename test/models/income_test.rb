require "test_helper"

class IncomeTest < ActiveSupport::TestCase
  setup do
    @household = households(:smith)
  end

  test "valid with amount, date and household" do
    income = Income.new(amount: 1000, date: Date.today, household: @household)
    assert income.valid?
  end

  test "invalid without household" do
    income = Income.new(amount: 1000, date: Date.today)
    assert_not income.valid?
  end

  test "invalid without amount" do
    income = Income.new(date: Date.today, household: @household)
    assert_not income.valid?
    assert_includes income.errors[:amount], "can't be blank"
  end

  test "invalid with zero amount" do
    income = Income.new(amount: 0, date: Date.today, household: @household)
    assert_not income.valid?
    assert_includes income.errors[:amount], "must be greater than 0"
  end

  test "invalid with negative amount" do
    income = Income.new(amount: -100, date: Date.today, household: @household)
    assert_not income.valid?
    assert_includes income.errors[:amount], "must be greater than 0"
  end

  test "invalid without date" do
    income = Income.new(amount: 1000, household: @household)
    assert_not income.valid?
    assert_includes income.errors[:date], "can't be blank"
  end

  test "note is optional" do
    assert Income.new(amount: 1000, date: Date.today, household: @household).valid?
    assert Income.new(amount: 1000, date: Date.today, note: "Bonus", household: @household).valid?
  end

  test "user is optional" do
    income = Income.new(amount: 1000, date: Date.today, household: @household)
    assert income.valid?
    income.user = users(:alice)
    assert income.valid?
  end
end
