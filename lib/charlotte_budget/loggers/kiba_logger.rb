require 'logger'

module CharlotteBudget
  module KibaLogger
    
    class << self
      attr_accessor :logger
      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end
    
    def self.included(klass)
      class << klass
        def logger
          ::CharlotteBudget::KibaLogger.logger
        end
      end
      
    end
    
    def logger
      self.class.logger
    end
    
  end
end

Kiba::Context.send(:include, CharlotteBudget::KibaLogger)