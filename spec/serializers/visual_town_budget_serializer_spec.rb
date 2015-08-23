require 'spec_helper'

describe CharlotteBudget::VisualTownBudgetSerializer do
  
  subject{ CharlotteBudget::VisualTownBudgetSerializer.new }
  let(:clazz){ CharlotteBudget::VisualTownBudgetSerializer }
  
  after(:each) do
    clazz.clear!
  end
  
  context "processing general fund entries" do
    let(:row_2015){
      {
        general_fund: true,
        fund: "General Fund",
        department: "Test Department",
        year: 2015,
        line_item: "Test Item",
        dollar_amount: 10
      }
    }
    let(:row_2016){
      {
        general_fund: true,
        fund: "General Fund",
        department: "Test Department",
        year: 2016,
        line_item: "Test Item",
        dollar_amount: 10
      }
    }
    let(:row_2016_2){
      {
        general_fund: true,
        fund: "General Fund",
        department: "Test Department",
        year: 2016,
        line_item: "Test Item Two",
        dollar_amount: 10
      }
    }    
    
    context "model" do
      it "should add a fund to expenses" do
        subject.process(row_2015)
        expect(clazz.funds.length).to eq(1)
      end
    
      it "should not add an item from an identical department in a later year" do
        subject.process(row_2015)
        subject.process(row_2016)
        expect(clazz.funds.length).to eq(1)
      end
      
      context "expansion" do
        it "should add a container within the general fund" do
          subject.process(row_2015)
          expect(clazz.funds.first.containers.length).to eq(1)
        end
        
        it "should not add a new container from an identical department in a later year" do
          subject.process(row_2015)
          subject.process(row_2016)
          expect(clazz.funds.first.containers.length).to eq(1)
          expect(clazz.funds.first.containers.first.containers.length).to eq(1)
        end
        
        it "should not add a department container with multiple year submissions" do
          subject.process(row_2015)
          subject.process(row_2016)
          subject.process(row_2016_2)
          expect(clazz.funds.first.containers.length).to eq(1)
        end
        
        it "should add a line item with multiple single year submissions" do
          subject.process(row_2015)
          subject.process(row_2016)
          subject.process(row_2016_2)
          expect(clazz.funds.first.containers.first.containers.length).to eq(2)
        end
      end
      
      context "annual expenses" do
        it "should reflect single year submission" do
          subject.process(row_2015)
          aes = clazz.expenses.annual_expenses
          expect(aes.length).to eq(1)
          e2015 = aes.first
          expect(e2015.year).to eq(2015)
          expect(e2015.val).to eq(10)
        end
    
        it "should reflect one 2016 submission" do
          subject.process(row_2015)
          subject.process(row_2016)
          aes = clazz.expenses.annual_expenses
          e2015 = aes.select{ |ae| ae.year == 2015 }.first
          e2016 = aes.select{ |ae| ae.year == 2016 }.first
          expect(e2015).not_to be_nil
          expect(e2016).not_to be_nil
          expect(e2016.val).to eq(10)
        end
        it "should reflect multiple 2016 submission" do
          subject.process(row_2015)
          subject.process(row_2016)
          subject.process(row_2016_2)
          aes = clazz.expenses.annual_expenses
          e2015 = aes.select{ |ae| ae.year == 2015 }.first
          e2016 = aes.select{ |ae| ae.year == 2016 }.first
          expect(e2015).not_to be_nil
          expect(e2016).not_to be_nil
          expect(e2016.val).to eq(20)
        end
      end
    end
    
  end
  
  context "processing other fund entries" do
    let(:row_2015){
      {
        fund: "Finance",
        year: 2015,
        line_item: "Test Item",
        dollar_amount: 10
      }
    }
    let(:row_2016){
      {
        fund: "Finance",
        year: 2016,
        line_item: "Test Item",
        dollar_amount: 10
      }
    }
    let(:row_2016_2){
      {
        fund: "Finance",
        year: 2016,
        line_item: "Test Item Two",
        dollar_amount: 10
      }
    }    
    
    context "model" do
      it "should add a fund to expenses" do
        subject.process(row_2015)
        expect(clazz.funds.length).to eq(1)
      end
    
      it "should not add an item from an identical department in a later year" do
        subject.process(row_2015)
        subject.process(row_2016)
        expect(clazz.funds.length).to eq(1)
      end
      
      context "expansion" do
        it "should add a line item within the fund" do
          subject.process(row_2015)
          expect(clazz.funds.first.containers.length).to eq(1)
        end
        
        it "should not add a new line item from an identical department in a later year" do
          subject.process(row_2015)
          subject.process(row_2016)
          expect(clazz.funds.first.containers.length).to eq(1)
        end
        
        it "should add a line item with multiple single year submissions" do
          subject.process(row_2015)
          subject.process(row_2016)
          subject.process(row_2016_2)
          expect(clazz.funds.first.containers.length).to eq(2)
        end
      end
      
      context "annual expenses" do
        it "should reflect single year submission" do
          subject.process(row_2015)
          aes = clazz.expenses.annual_expenses
          expect(aes.length).to eq(1)
          e2015 = aes.first
          expect(e2015.year).to eq(2015)
          expect(e2015.val).to eq(10)
        end
    
        it "should reflect one 2016 submission" do
          subject.process(row_2015)
          subject.process(row_2016)
          aes = clazz.expenses.annual_expenses
          e2015 = aes.select{ |ae| ae.year == 2015 }.first
          e2016 = aes.select{ |ae| ae.year == 2016 }.first
          expect(e2015).not_to be_nil
          expect(e2016).not_to be_nil
          expect(e2016.val).to eq(10)
        end
        
        it "should reflect multiple 2016 submission" do
          subject.process(row_2015)
          subject.process(row_2016)
          subject.process(row_2016_2)
          aes = clazz.expenses.annual_expenses
          e2015 = aes.select{ |ae| ae.year == 2015 }.first
          e2016 = aes.select{ |ae| ae.year == 2016 }.first
          expect(e2015).not_to be_nil
          expect(e2016).not_to be_nil
          expect(e2016.val).to eq(20)
        end
      end
    end
  end
end