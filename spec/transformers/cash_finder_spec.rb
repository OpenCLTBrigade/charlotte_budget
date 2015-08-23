require 'spec_helper'

describe CharlotteBudget::CashFinder do
  
  subject{ CharlotteBudget::CashFinder.new(0, 1) }
  let(:nil_row){ {row: ["Test Category", nil]}}
  let(:blank_row){ {row: ["Test Category", ""]}}
  let(:zero_row){ {row: ["Test Category", "0"]}}
  let(:simple_row){ {row: ["Test Category", "100"]}}
  let(:row){ {row: ["Test Category", "9,000"]}}
  let(:negative){ {row: ["Test Category", "-9,000"]}}
  
  it "should expose line item" do
    findings = subject.process(zero_row)
    expect( findings[:line_item] ).to eq("Test Category")
  end
  
  it "should find cash in a zero row" do
    findings = subject.process(zero_row)
    expect( findings[:dollar_amount] ).to eq(0)
  end
  
  it "should find cash in a simple row" do
    findings = subject.process(simple_row)
    expect( findings[:dollar_amount] ).to eq(100)
  end
  
  it "should find cash in a typical row" do
    findings = subject.process(row)
    expect( findings[:dollar_amount] ).to eq(9000)
  end
  
  it "should find cash in a negative row" do
    findings = subject.process(negative)
    expect( findings[:dollar_amount] ).to eq(-9000)
  end    
  
end