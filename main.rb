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
require_relative 'lib/v2/util'
require_relative 'lib/v2/parse'
#----------------------

# Data for the report
# Very jank for now - but a "month" will always be a pair of statements
# All expenses should be averaged by dividing occurence by .5 of @number_of_statements
@number_of_statements = 0
@expense_history = []

statements = Dir["./statements/*"]
tables = []
statements.each do |statement|
  @number_of_statements = V2::Util.statement_types_count(statement, @number_of_statements)
  tables.push(V2::Util.parsed_table(statement))
end

desc_history = V2::Parse.table_descs(tables)
desc_history.uniq.map do |desc_key|
  @expense_history.push(V2::Parse.count_rows_by_desc(desc_key, tables))
end
puts @expense_history
puts @number_of_statements
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
