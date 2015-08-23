require 'multi_json'
require 'digest'

module CharlotteBudget
  class VisualTownBudgetSerializer < Transformer
    class Container

      attr_accessor :key, :containers
    
      def initialize(attrs={})
        @key = attrs[:key]
        @containers = attrs[:containers] || []
      end
      
      def hashify
        md5 = Digest::MD5.new
      	md5.update(self.key)
      	md5.hexdigest()
      end

      def to_hash
        {
          key: key,
          src: nil,
          hash: hashify,
          sub: containers.collect{ |c| c.to_hash },
          descr: nil,
          values: annual_expenses.collect{ |c| c.to_hash }
        }
      end
    
      def tracked?(val)
        !container_for(val).nil?
      end
    
      def container_for(val)
        containers.select{ |c| c.key == val }.first
      end
    
      def record(attrs)
        li = container_for(attrs[:line_item])
        if li.nil?
          li = LineItem.new(attrs[:line_item])
          containers << li
        end
        ae = AnnualExpense.new
        ae.val = attrs[:dollar_amount]
        ae.year = attrs[:year]
        li.annual_expenses << ae
        li
      end
    
      def annual_expenses
        raw_expenses = containers.collect{ |c| c.annual_expenses }.flatten
        # Just so happens VTB viz requires spanning years.
        #covered_years = raw_expenses.collect{ |e| e.year }.sort.uniq
        covered_years.collect do |y|
          ae = AnnualExpense.new
          ae.year = y
          ae.val = raw_expenses.select{|e| e.year == y}.inject(0){ |sum, elt| sum += elt.val}
          ae
        end
      end
      
      def covered_years
        [2015, 2016]
      end
      
      def to_s
        "[#{key}] [#{containers.collect{ |c| c.to_s}}]"
      end
    end

    class LineItem
      attr_accessor :key, :annual_expenses
      
      def initialize(name)
        @key = name
        @annual_expenses = []
      end
      
      def hashify
        md5 = Digest::MD5.new
      	md5.update(self.key)
      	md5.hexdigest()
      end      
    
      def to_hash
        { descr: nil,
          src: nil,
          hash: hashify,
          sub: [],
          key: key,
          url: nil,
          values: spanning_annual_expenses.collect{ |v| v.to_hash }
        }
      end
      
      def covered_years
        [2015, 2016]
      end
      
      def spanning_annual_expenses
        aes = annual_expenses
        years = aes.collect{ |ae| ae.year }
        off_years = covered_years - years
        off_years.each do |y|
          ae = AnnualExpense.new
          ae.year = y
          ae.val = 0
          aes << ae
        end
        aes
      end
      
      def to_s
        "{#{key}} #{annual_expenses.join(",")}"
      end
    
    end
    class AnnualExpense
      attr_accessor :val, :year
      def to_hash
        {
          val: self.val,
          year: self.year
        }
      end
      def to_s
        "#{val} in #{year}"
      end
    end
  
    class << self
      def expenses
        @expenses ||= Container.new(key: "Expenses")
      end
      def funds
        expenses.containers
      end
      def write(path)
        File.open(path, 'w') { |f|
          f.write(MultiJson.dump(expenses.to_hash))
        }
      end
      def clear!
        @expenses = Container.new(key: "Expenses")
      end
    end
  
    def process(row)
      expenses = self.class.expenses
      track(row[:fund]) if !expenses.tracked?(row[:fund])
      if row[:general_fund]
        gf = expenses.container_for(row[:fund])
        dept = gf.container_for(row[:department])
        if dept.nil?
          dept = new_container(row[:department])
          gf.containers << dept
        end
        logger.debug("Recording row under #{dept.key}")
        dept.record(row)
      else
        fund = expenses.container_for(row[:fund])
        if fund.nil?
          fund = new_container(row[:fund])
          expenses.containers << dept
        end
        logger.debug("Recording row under #{fund.key}")
        fund.record(row)
      end
    end
  
    def track(fund)
      self.class.expenses.containers << new_container(fund)
    end
  
    def new_container(fund)
      Container.new(key: fund)
    end
  
  end
end