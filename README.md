# Using Ruby to parse CSV and generate a report

if table.by_col[0][0].split(" ")[0] == "Account" it is a bank statement

## If a CACU statement column mappings are as follows

Description Column
table.by_col[2]

Date Column
table.by_col[1]

Amount Column
table.by_col[4]

## If a Credit Statement column mappings are as follows

Description Column
table.by_col[2]

Amount Column 
table.by_col[5]

Date Column
table.by_col[0]

## Development process

1. I want an array of the months covered in the statements [:july => {}, :august => {}]
   1. Each statement will only contain a single month or 2 months max
   2. We can determine the two month statement by checking the month of the first entry and the month of the last
2. Inside the month hash I want the description & the amount {"groceries" => -100}
