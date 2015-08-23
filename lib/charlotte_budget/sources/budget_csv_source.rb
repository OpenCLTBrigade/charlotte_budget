require 'csv'

# The most fundamental level of processing.  
# Ensures origin file, year, and row info is available throughout processing.
class BudgetCsvSource
  def initialize(input_file, year)
    @csv = CSV.open(input_file, headers: false)
    @year = year
    @filename = input_file.split("/").last
  end

  def each
    @csv.each_with_index do |row, i|
      yield(year: @year, file: @filename, row_index: i+1, row: row)
    end
    @csv.close
  end
end