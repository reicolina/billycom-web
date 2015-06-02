class BilledTax < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :name, :rate
  belongs_to :site
  belongs_to :bill
  
  def recalculate
    total_charges = BilledCall.sum(:amount_charged, :conditions => "bill_id = " + self.bill_id.to_s) + BilledLine.sum(:amount_charged, :conditions => "bill_id = " + self.bill_id.to_s) + BilledService.sum(:amount_charged, :conditions => "bill_id = " + self.bill_id.to_s) + BilledAdjustment.sum(:amount_charged, :conditions => "bill_id = " + self.bill_id.to_s)
    self.amount_charged = self.calculate_amount(total_charges)
    self.save
    total_charges = nil  
  end
  
  def calculate_amount(total)
    (total) * (self.rate/100)
  end
  
end
