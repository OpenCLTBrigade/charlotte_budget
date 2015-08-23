module CharlotteBudget
  class CashCounter < Transformer
    
    class << self
      attr_accessor :funds
      
      def funds
        @funds ||= {}
      end
      
      def clear!
        @funds = {}
      end
      
      def subtotal(fund, year)
        funds[fund][year].inject(0){ |sum, elt| sum += elt.last }
      end
    end
    
    def process(row)
      aggregate(row)
      row
    end
    
    def aggregate(row)
      fund = self.class.funds[row[:fund]]
      if fund.nil?
        logger.info("Aggregating #{row[:fund]}")
        self.class.funds[row[:fund]] = fund = {}
      end
      yearly_line_items = fund[row[:year]]
      if yearly_line_items.nil?
        logger.debug("Initiating line items in #{row[:fund]} for #{row[:year]}")
        fund[row[:year]] = {}
      end
      fund[row[:year]][row[:line_item]] = row[:dollar_amount]
    end
    
  end
end