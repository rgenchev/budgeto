require "test_helper"

class TaxTest < ActiveSupport::TestCase
  test "valid with amount and date" do
    tax = Tax.new(amount: 100, date: Date.today)
    assert tax.valid?
  end

  test "invalid without amount" do
    tax = Tax.new(date: Date.today)
    assert_not tax.valid?
    assert_includes tax.errors[:amount], "can't be blank"
  end

  test "invalid without date" do
    tax = Tax.new(amount: 100)
    assert_not tax.valid?
    assert_includes tax.errors[:date], "can't be blank"
  end

  test "invalid with zero amount" do
    tax = Tax.new(amount: 0, date: Date.today)
    assert_not tax.valid?
    assert_includes tax.errors[:amount], "must be greater than 0"
  end

  test "invalid with negative amount" do
    tax = Tax.new(amount: -50, date: Date.today)
    assert_not tax.valid?
    assert_includes tax.errors[:amount], "must be greater than 0"
  end
end
