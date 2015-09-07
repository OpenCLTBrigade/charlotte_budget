require 'csv'
module CharlotteBudget
  class CommunityBudgetExplorerSerializer < Transformer
  
    class << self
      def general_fund
        @general_fund ||= {}
      end
      def general_fund_department(dept_name)
        dept = general_fund[dept_name]
        if dept.nil?
          dept = {}
          general_fund[dept_name] = dept
        end
        dept
      end
      def other_funds
        @other_funds ||= {}
      end
    
      def fund(fund_name)
        f = other_funds[fund_name]
        if f.nil?
          f = {}
          other_funds[fund_name] = f
        end
        f
      end
    
      def write(path)
        CSV.open(path, 'wb') { |csv|
          header_row = []
          header_row[0] = "Type"
          header_row[1] = "Amount"
          header_row[2] = "Fund"
          header_row[3] = "Department"
          header_row[4] = "Account Name"
          general_fund.each do |dept, accts|
            logger.debug dept.inspect
            accts.each do |acct, val|
              row = []
              row[0] = "EXPENSE"
              row[1] = val
              row[2] = "General Fund"
              row[3] = dept
              row[4] = acct
              csv << row
            end
          end
          other_funds.each do |fund, accts|
            logger.debug fund.inspect
            accts.each do |acct, val|
              row = []
              row[0] = "EXPENSE"
              row[1] = val
              row[2] = fund
              row[3] = fund
              row[4] = acct
              csv << row
            end
          end
        }
      end
      def clear!
        @general_fund = {}
        @other_funds = {}
      end
    end
  
    def process(row)
      if row[:general_fund]
        record(self.class.general_fund_department(row[:department]), row)
      else
        record(self.class.fund(row[:fund]), row)
      end
      row
    end
  
    def record(container, row)
      # FIXME: record needs multi-year capability [jvf]
      line_item = container[row[:line_item]]
      if line_item.nil?
        logger.debug("New line item: #{row[:line_item]}")
        container[row[:line_item]] = line_item = 0
      else
        logger.debug("Existing line item: #{row[:line_item]} (#{container[row[:line_item]]})")
      end
      container[row[:line_item]] = line_item + row[:dollar_amount]
      logger.debug("New value: #{container[row[:line_item]]}")
    end
  end
end