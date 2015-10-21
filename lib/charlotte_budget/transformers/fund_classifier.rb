module CharlotteBudget
  class FundClassifier < Transformer
    
    def process(row)
      classify(row)
      row if row[:fund]
    end
    
    def classify(row)
      # General Fund is split into departments
      # Some departments are self-funded and are split out
      # These self-funded departments were once under the General Fund
      # and have deparment codes too.
      row[:fund] = fund_lookup(fund_code(row[:department_code]))
      if general_fund?(row)
        row[:department] = dept_lookup(dept_code(row[:department_code]))
        if row[:department] == "Unknown"
          logger.warn "Unknown department"
          logger.warn row[:row]
        end
        row[:general_fund] = true
      else
        row[:fund] = dept_lookup(dept_code(row[:department_code]))
      end
      row
    end
        
    def fund_lookup(code)
      case code
      when "1000", "1001"
        "General Fund"
      else
        "Fund #{code}"
      end
    end

    def dept_lookup(code)
      case code
      when "00"
      	"Non Department"
      when "10"
      	"Mayor & Council"
      when "11"
      	"City Manager"
      when "12"
      	"City Clerk"
      when "13"
      	"City Attorney"
      when "14"
      	"Budget & Evaluation"
      when "15"
      	"Shared Services"
      when "16"
      	"Finance"
      when "17"
      	"Human Resources"
      when "18"
      	"Innovation & Technology"
      when "19"
        "Management & Financial Services"
      when "30"
      	"Charlotte Mecklenburg Police"
      when "31"
      	"Fire"
      when "40"
      	"Aviation"
      when "41"
      	"Charlotte Area Transit System"
      when "42"
      	"Charlotte Department of Transportation"
      when "50"
      	"Solid Waste Services"
      when "60"
      	"Charlotte-Mecklenburg Planning"
      when "61"
      	"Neighborhood & Business Services"
      when "70"
      	"Charlotte Water (formerly Charlotte Mecklenburg Utility Department)"
      when "80"
      	"Engineering & Property Management"
      else
        "Unknown"
      end
    end
    
    private
    
    def general_fund?(row)
      row[:fund] == "General Fund"
    end
    
    def fund_code(code)
      code.split("-")[0]
    end
    
    def dept_code(code)
      code.split("-")[1]
    end
    
    
  end
end