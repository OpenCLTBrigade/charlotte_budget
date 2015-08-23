module CharlotteBudget
  class CashFinder < Transformer
    
    attr_accessor :line_item_column, :cash_column
    
    def initialize(line_item_column, cash_column)
      @line_item_column = line_item_column
      @cash_column = cash_column
    end
    
    def process(row)
      find_cash(row)
      row if row[:dollar_amount]
    end
    
    def find_cash(row)
      raw_row = row[:row]
      row[:line_item] = raw_row[@line_item_column]
      row[:dollar_amount] = raw_row[@cash_column].gsub(',','').to_i
    end
    
  end
end