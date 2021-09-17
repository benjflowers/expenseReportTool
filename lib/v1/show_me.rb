require 'csv'
module V1
  module ShowMe
    class << self
      def tables_from(statements)
        tables = []
  
        if statements.length > 0
          statements.each do |statement|
            tables.push(CSV.parse(File.read(statement), headers: true))
          end
        else
          tables.push(CSV.parse(File.read(statements), headers: true))
        end
  
        tables
      end

      def months_from(tables)
        months = []

        tables.each do |table|
          months.push(pull_date_from(table))
        end

        months.flatten.uniq!
      end

      private

      def pull_date_from(table)
        dates = []

        table.each do |row|
          dates.push(month_as_str(row[1]))
        end

        dates.uniq
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