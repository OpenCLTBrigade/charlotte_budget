module CharlotteBudget
  class DepartmentCodeReader < Transformer
    
    attr_accessor :column
    
    def initialize(column)
      @column = column
    end
    
    def process(row)
      lookup(row)
      row if row[:department_code]
    end
    
    def lookup(row)
      code = row[:row][column]
      return unless valid?(code)
      row[:department_code] = code
    end
    
    def valid?(code)
      (code =~ regex) == 0
    end
    
    private
    
    def regex
      /(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-/
    end
    
  end
end