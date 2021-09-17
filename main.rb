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
require_relative 'lib/v1/show_me'
#----------------------

# Data for the report
@expense_history = []

tables = V1::ShowMe.tables_from(Dir["./statements/*"])
months_reported = V1::ShowMe.months_from(tables)

puts months_reported

# WE NEED ALL THIS STUFF
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
