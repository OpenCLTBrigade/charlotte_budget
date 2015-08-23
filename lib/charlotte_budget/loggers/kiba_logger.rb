require 'logger'

module CharlotteBudget
  module KibaLogger
    
    
    def self.included(klass)
      puts "included in #{klass.to_s}"
      class << klass
        attr_accessor :logger
        def logger
          @logger ||= Logger.new(STDOUT)
        end
      end
    end
    
    def logger
      self.class.logger
    end
    
  end
end

Kiba::Context.send(:include, CharlotteBudget::KibaLogger)