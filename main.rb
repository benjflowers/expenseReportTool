require 'csv'
require 'pp'
require 'date'

statements = Dir["./statements/*"]
history = []
table = CSV.parse(File.read(statements[2]), headers: true)

# Inserts expense objects...
# expense_object: [{ @description: @amount }...]
statements.each do |statement|
  table = CSV.parse(File.read(statement), headers: true)

  if table.by_col[0][0].split(" ")[0] == "Account"
    table.by_col[2][3..-1].each_with_index do |description, index|
      formatted_date = table.by_col[1][3..-1][index].split("/")
      date = Date.new(
        formatted_date[2].to_i,
        formatted_date[0].to_i,
        formatted_date[1].to_i
      )
      month = date.strftime("%b")
      entry = { "#{month}": {"#{description}": table.by_col[4][3..-1][index]} }
      history.push(entry)
    end
  else
    table.by_col[2].each_with_index do |description, index|
      formatted_date = table.by_col[1][3..-1][index].split("/")
      date = Date.new(
        formatted_date[2].to_i,
        formatted_date[0].to_i,
        formatted_date[1].to_i
      )
      month = date.strftime("%b")
      entry = { "#{month}": {"#{description}": table.by_col[5][3..-1][index]} }
      history.push(entry)
    end
  end
end

months_reported = []

history.each do |item|
  months_reported.push(item.keys[0])
end

thing = {}

months_reported.uniq.each do |month|
  thing["#{month}"] = []
end

history.each do |item|
  month = item.keys[0]
  thing["#{month}"].push(item)
end

history = []
history.push(thing)

pp history
