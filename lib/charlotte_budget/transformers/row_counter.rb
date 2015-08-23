module CharlotteBudget
  class RowCounter < Transformer
    
    class << self
      attr_accessor :year_counts, :file_counts
      
      def year_counts
        @year_counts ||= Hash.new(0)
      end
      
      def file_counts
        @file_counts ||= Hash.new(0)
      end
      
      def report
        logger.info("Thank you for processing the #{years} City of Charlotte budget!")
        total_rows = year_counts.inject(0){|sum, elt| sum+=elt.last}
        logger.info("I processed #{total_rows} rows from #{year_counts.count} years and #{file_counts.count} files of data.")
      end
      
      def years
        [year_counts.keys.sort.first, year_counts.keys.sort.last].join("-")
      end
    end

    def process(row)
      count_row(row)
      row
    end
    
    def count_row(row)
      self.class.year_counts[row[:year]] += 1
      self.class.file_counts[row[:file]] += 1
    end
    
  end
end