require 'spec_helper'

describe CharlotteBudget::DepartmentCodeReader do
  
  subject{ CharlotteBudget::DepartmentCodeReader.new(0) }
  
  let(:code){ "6200-70-00-7090-709080-000000-000-521910-" }
  let(:invalid){ "ACCOUNT" }
  
  context "parsing" do
    
    it "should determine validity" do
      expect( subject.valid?(code) ).to be(true)
      expect( subject.valid?(invalid) ).to be(false)
    end
    
  end
  
end