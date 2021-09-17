# QOL - DEV
require 'pp'
require 'pry'
#---------------

# Dependencies
require 'csv'
require 'date'
#--------------

# Report dependencies
require 'erb'
require 'launchy'
#---------------------

# Module imports
require_relative 'lib/v1/util'
require_relative 'lib/v1/parse'
#----------------------

# Data for the report
@expense_history = []

statements = Dir["./statements/*"]
tables = []
statements.each do |statement|
  tables.push(V1::Util.parsed_table(statement))
end

desc_history = V1::Parse.table_descs(tables)
desc_history.uniq.map do |desc_key|
  @expense_history.push(V1::Parse.count_rows_by_desc(desc_key, tables))
end
puts @expense_history
# puts history.flatten
# puts tables

# # render template
# template = File.read('./template.html.erb')
# result = ERB.new(template).result(binding)

# # write result to file
# File.open('template.html', 'w+') do |f|
#   f.write result
# end

# Launchy.open("./template.html")
