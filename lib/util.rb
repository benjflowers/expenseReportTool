require 'date'
require 'csv'

module Util
  # Insert the Month hash into the final summary array
  #
  # @returns: nil
  # @params: expense_summary - Array - []
  # @params: satements - CSV - Object
  def insert_months_into_summary(statements, expense_summary = [])
    all_months = []
    statements.each do |statement|
      # entire table as an object
      table = CSV.parse(File.read(statement), headers: true)

      # Date column in table: Array []
      date_column = table.by_col[1][3..-1]

      month_in(date_column[0])
      month_in(date_column[-1])

      all_months.push(collected_months_in_column(date_column))
    end

    all_months.flatten.uniq.each do |month|
      expense_summary.push({"#{month}": []})
    end
  end

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
  
      expense_summary.each do |month|
        monthly_expenses = data.select {|entry| entry.key?(month.keys[0])}
        monthly_expenses.each do |expense|
          month[month.keys[0]].push(expense[month.keys[0]])
        end
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

  # Returns an array of the months included in the statement
  #
  # @returns: Array - ["Jul", "Jun"]
  # @params: date_column - Array - ["06/24/2021"]
  def collected_months_in_column(date_column)
    collection = []
    collection.push(month_in(date_column[0]))
    collection.push(month_in(date_column[-1]))

    collection
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
        "#{month_in(row[date_index])}": {
          "#{row[desc_index]}": row[amount_index]
        }
      })
    end

    entries
  end
end