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
include Util
#----------------------

statements = Dir["./statements/*"]
# Final return
expense_summary = []
insert_months_into_summary(statements, expense_summary)
populate_months_in_summary(statements, expense_summary)

@expense_summary = expense_summary

# render template
template = File.read('./template.html.erb')
result = ERB.new(template).result(binding)

# write result to file
File.open('template.html', 'w+') do |f|
  f.write result
end

Launchy.open("./template.html")
