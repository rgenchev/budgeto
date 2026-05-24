require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  setup do
    @household = households(:smith)
    @category  = categories(:groceries)
  end

  test "valid with required fields" do
    expense = Expense.new(amount: 50, date: Date.today, category: @category, household: @household)
    assert expense.valid?
  end

  test "invalid without household" do
    expense = Expense.new(amount: 50, date: Date.today, category: @category)
    assert_not expense.valid?
  end

  test "invalid without amount" do
    expense = Expense.new(date: Date.today, category: @category, household: @household)
    assert_not expense.valid?
    assert_includes expense.errors[:amount], "can't be blank"
  end

  test "invalid with zero amount" do
    expense = Expense.new(amount: 0, date: Date.today, category: @category, household: @household)
    assert_not expense.valid?
    assert_includes expense.errors[:amount], "must be greater than 0"
  end

  test "invalid without date" do
    expense = Expense.new(amount: 50, category: @category, household: @household)
    assert_not expense.valid?
    assert_includes expense.errors[:date], "can't be blank"
  end

  test "user is optional" do
    expense = Expense.new(amount: 50, date: Date.today, category: @category, household: @household)
    assert expense.valid?
    expense.user = users(:alice)
    assert expense.valid?
  end

  test "duplicate amount, category, date and note is invalid" do
    existing = expenses(:alice_groceries)
    duplicate = Expense.new(
      amount: existing.amount,
      date: existing.date,
      note: existing.note,
      category: existing.category,
      household: @household
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:amount], "duplicate expense already exists"
  end
end
