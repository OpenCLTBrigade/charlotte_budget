require 'spec_helper'

describe CharlotteBudget::CashCounter do
  
  let(:rows){ [
    {fund: "General Fund", line_item: "Test Item", year: 2015, dollar_amount: 10},
    {fund: "General Fund", line_item: "Test Item 2", year: 2015, dollar_amount: 10},
    {fund: "General Fund", line_item: "Test Item 2", year: 2016, dollar_amount: 10}    
  ]}
  
  subject{ CharlotteBudget::CashCounter }
  
  after(:each) do
    subject.clear!
  end
  
  before(:each) do
    rows.each { |row| subject.new.process(row) }
  end
  
  it "should aggregate under fund, year, and line item at counts" do
    expect( subject.funds ).to include("General Fund")
  end
  
  it "should aggregate line items under fund and year" do
    expect( subject.subtotal("General Fund", 2015) ).to eq(20)
    expect( subject.subtotal("General Fund", 2016) ).to eq(10)
  end
  
end