require 'date'
require 'csv'

require_relative '../model/Expense'

module Util
  def populate_months_in_summary(statements, expense_summary)
    statements.each do |statement|
      data = []
      table = CSV.parse(File.read(statement), headers: true)
      # if bank CACU statement we have to alter
      # where we access rows
      if table[0][0].include?("Account")
        # entry_index = 3
        # date_index = 1
        # desc_index = 2
        # amount_index = 4
  
        data = extracted_table_row_data(
          table: table[3..-1],
          date_index: 1,
          desc_index: 2,
          amount_index: 4
        )
      else
        # entry_index = 0
        # date_index = 0
        # desc_index = 2
        # amount_index = 5
  
        data = extracted_table_row_data(
          table: table[0..-1],
          date_index: 0,
          desc_index: 2,
          amount_index: 5
        )
      end

      data.each do |expense|
        expense_summary.push(Expense.new(expense))
      end
    end
  end

  private
  # Returns the string value of a month given its integer
  #
  # @return: String - "Jul"
  # @params: date - Array - ["06", "24", "2021"]
  def month_in(date)
    date = date.split("/")
    # Date.new requires Y/M/D
    Date.new(
      date[2].to_i,
      date[0].to_i,
      date[1].to_i
    ).strftime("%b")
  end

  # Extract the description and amounts from each row
  #
  # @returns: Array [{description: amount}]
  # @params: table - Array - []
  # @params: desc_index - Int - 2
  # @params: amount_index - Int - 4
  def extracted_table_row_data(table: [], date_index: 0, desc_index: 0, amount_index: 0)
    entries = []
    table.each do |row|
      if row[amount_index] == nil
        row[amount_index] = "0"
      end
      entries.push({
        details: row[desc_index].split(" ").first,
        amount: row[amount_index].to_i,
        month: month_in(row[date_index])
      })
    end

    entries
  end
end