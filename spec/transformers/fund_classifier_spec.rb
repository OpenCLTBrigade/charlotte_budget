require 'spec_helper'

describe CharlotteBudget::FundClassifier do
  subject{ CharlotteBudget::FundClassifier.new }
  
  let(:water_insurance_premiums){ {department_code: "6200-70-00-7090-709040-000000-000-523000-"} }
  let(:general_fund_printing){ {department_code: "1000-80-80-8060-000000-000000-000-529040-" } }
  let(:cdot_resurfacing){ {department_code: "1001-42-42-4270-000000-000000-000-520471-"} }
  
  
  context "fund lookup" do
    it "should identify a general fund code" do
      classification = subject.classify(general_fund_printing)
      expect(classification[:fund]).to eq("General Fund")
    end
    
    it "should find CDOT resurfacing in the general fund in 2015" do
      classification = subject.classify(cdot_resurfacing)
      expect(classification[:fund]).to eq("General Fund")
    end
    
    it "should identify a non-general fund code" do
      classification = subject.classify(water_insurance_premiums)
      expect(classification[:fund]).to eq("Charlotte Water (formerly Charlotte Mecklenburg Utility Department)")
    end
  end
  
  context "department lookup" do
    it "should identify a general fund department code" do
      classification = subject.classify(general_fund_printing)
      expect(classification[:department]).to eq("Engineering & Property Management")
    end
    
    it "should not be processed for standalone funds" do
      classification = subject.classify(water_insurance_premiums)
      expect(classification[:department]).to be_nil
    end
  end
  
end