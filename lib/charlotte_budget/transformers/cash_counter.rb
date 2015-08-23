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
      
      def department_subtotal(fund, year, department)
        funds[fund][year][department].inject(0){ |sum, elt| sum += elt.last }
      end      
      
      def report
        general_fund = funds["General Fund"]
        general_fund.keys.each { |year|
          fund = "General Fund" 
          general_fund[year].keys.each do |department|
            dollar_subtotal = department_subtotal(fund, year, department).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
            logger.info("[#{fund}][#{year}][#{department}] #{dollar_subtotal}")
          end
        }
        funds.keys.each{ |fund| 
          next if fund == "General Fund"
          funds[fund].keys.each { |year| 
            dollar_subtotal = subtotal(fund, year).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
            logger.info("[#{fund}][#{year}] #{dollar_subtotal}")
          }
        }
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
      if row[:general_fund]
        department_line_items = fund[row[:year]][row[:department]]
        if department_line_items.nil?
          logger.debug("Aggregating line items for general fund department #{row[:department]} for #{row[:year]}")
          fund[row[:year]][row[:department]] = {}
        end
        fund[row[:year]][row[:department]][row[:line_item]] = ((fund[row[:year]][row[:department]][row[:line_item]]||0) + row[:dollar_amount])
      else
        fund[row[:year]][row[:line_item]] = ((fund[row[:year]][row[:line_item]]||0) + row[:dollar_amount])
      end
    end
    
  end
end