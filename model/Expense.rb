class Expense
  attr_accessor :details, :amount, :month
  def initialize(details: "idk", amount: 0, month: "Feb")
    @details = details,
    @amount = amount,
    @month = month
  end
end