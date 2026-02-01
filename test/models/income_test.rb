require "test_helper"

class IncomeTest < ActiveSupport::TestCase
  test "valid with amount and date" do
    income = Income.new(amount: 1000, date: Date.today)
    assert income.valid?
  end

  test "invalid without amount" do
    income = Income.new(date: Date.today)
    assert_not income.valid?
    assert_includes income.errors[:amount], "can't be blank"
  end

  test "invalid with zero amount" do
    income = Income.new(amount: 0, date: Date.today)
    assert_not income.valid?
    assert_includes income.errors[:amount], "must be greater than 0"
  end

  test "invalid with negative amount" do
    income = Income.new(amount: -100, date: Date.today)
    assert_not income.valid?
    assert_includes income.errors[:amount], "must be greater than 0"
  end

  test "invalid without date" do
    income = Income.new(amount: 1000)
    assert_not income.valid?
    assert_includes income.errors[:date], "can't be blank"
  end

  test "valid without note" do
    income = Income.new(amount: 1000, date: Date.today)
    assert income.valid?
  end

  test "valid with note" do
    income = Income.new(amount: 1000, date: Date.today, note: "January salary")
    assert income.valid?
  end
end
