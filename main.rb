require 'csv'
require 'pp'

statements = Dir["./statements/*"]
history = []
table = CSV.parse(File.read(statements[2]), headers: true)

statements.each do |statement|
  table = CSV.parse(File.read(statement), headers: true)
  entry = {}
  if table.by_col[0][0].split(" ")[0] == "Account"
    table.by_col[2][3..-1].each_with_index do |description, index|
      history.push({"#{description}": table.by_col[4][3..-1][index]})
    end
  else
    table.by_col[2].each_with_index do |description, index|
      history.push({"#{description}": table.by_col[5][index]})
    end
  end
end

print history
