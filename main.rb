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
require_relative 'lib/util'
require_relative 'model/Expense'
include Util
#----------------------

statements = Dir["./statements/*"]
# Final return
@expense_summary = []
populate_months_in_summary(statements, @expense_summary)

@expense_summary.each do |expense|
  expense.details = expense.details[0]
end

@months = []

@expense_summary.each do |expense|
  unless @months.include?(expense.month)
    @months.push(expense.month)
  end
end

# render template
template = File.read('./template.html.erb')
result = ERB.new(template).result(binding)

# write result to file
File.open('template.html', 'w+') do |f|
  f.write result
end

Launchy.open("./template.html")
