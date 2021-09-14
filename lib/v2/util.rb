require 'csv'
# Functionality to serve each statement
# Prioritizing the preservation of each statement and enabling access of all points
module V2
  module Util
    BANK_TYPE = "bank"
    # Parses through a local CSV file 
    #
    # return_type -> CSV::Table
    #
    # @statement  -> Local CSV File
    class << self
      def parsed_table(statement)
        table = CSV.parse(File.read(statement), headers: true)
  
        # manipulate starting place of table to avoid irrelevant account info
        if table[0][0].include?("Account")
          table = table[3..-1]
          return formatted(table, type: BANK_TYPE)
        else
          table = table[0..-1]
          return formatted(table)
        end
      end

      private
      def formatted(table, type: nil)
        format_descriptions(table)
        format_date(table, type)
      end
  
      # Format the description to a simpler string
      #
      # return_type -> Array
      #
      # @table      -> Array
      def format_descriptions(table)
        table.each do |row|
          row[2] = row[2].split(" ")[0]
        end
      end
  
      def format_date(table, type)
        table.each do |row|
          if type == "bank"
            row[1] = month_as_str(row[1])
          else
            row[0] = month_as_str(row[0])
          end
        end
      end
  
      def month_as_str(date)
        date = date.split("/")
        # Date.new requires Y/M/D
        Date.new(
          date[2].to_i,
          date[0].to_i,
          date[1].to_i
        ).strftime("%b")
      end
    end
  end
end