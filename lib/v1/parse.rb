module V1
  module Parse
    DESC_INDEX = 2

    class << self
      def table_descs(tables)
        desc_history = []
        tables.each do |table|
          accumulate_history(table, desc_history)
        end

        return desc_history.flatten
      end

      def rows_by_desc(table, desc_history)
        desc_entries = []
        desc_history.uniq.each do |entry|
          rows = table.select { |row| row[DESC_INDEX] }
          desc_entries.push({"#{entry}": rows}) 
        end

        return desc_entries
      end

      def count_rows_by_desc(desc_key, tables)
        count = 0
        total_spent = 0

        tables.each do |table|
          relevent_rows = table.select { |row| row[DESC_INDEX] == desc_key }

          count += relevent_rows.count

          relevent_rows.each do |row|
            binding.pry
            if row[0] == "Transaction Number"
              total_spent += row[4].to_i
            else
              total_spent += row[5].to_i
            end
          end
        end

        return {"#{desc_key}": {count: count, total_spent: total_spent}}
      end

      private
      def accumulate_history(table, desc_history)
        table.each do |row|
          desc_history.push(row[DESC_INDEX])
        end

        return desc_history
      end
    end
  end
end