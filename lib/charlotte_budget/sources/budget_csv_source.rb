require 'csv'

# The most fundamental level of processing
class BudgetCsvSource
  def initialize(input_file)
    @csv = CSV.open(input_file, headers: false)
  end

  def each
    @csv.each do |row|
      yield(row)
    end
    @csv.close
  end
end