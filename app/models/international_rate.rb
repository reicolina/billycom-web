class InternationalRate < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :international_plan_id, :code, :destination, :rate, :call_type, :increment_in_seconds
  belongs_to :site
  belongs_to :international_plan
  validates_presence_of :code
  validates_numericality_of :code
  validates_uniqueness_to_tenant :code, :scope => [:call_type, :international_plan_id]
  validates_presence_of :destination
  validates_presence_of :rate
  validates_numericality_of :rate
  validates_presence_of :increment_in_seconds
  validates_numericality_of :increment_in_seconds, :greater_than =>0
  paginates_per Source::Application.config.items_per_page
  
  class << self
    
    def delete_all()
      @rates = self.all
      self.destroy(@rates)    
    end

    def import_rates(parsed_file,id)
      n=0
      parsed_file.each  do |row|
        @rate=self.new
        @rate.international_plan_id = id
        @rate.code=row[0]
        @rate.destination=row[1]
        @rate.rate=row[2]
        @rate.call_type=row[3]
        if @rate.save
            n=n+1
            if n%Source::Application.config.gc_start_loop_count==0
              Rails.logger.info "MEMORY_MANAGEMENT: [import_rates] starting garbage collector after " + n.to_s + " loops"
              GC.start
            end
        end
      end
      n  
    end

    def find_by_number(number, call_type)
        if call_type == CallTypeInfo::CARIBBEAN or call_type == CallTypeInfo::CARIBBEAN_MOBILE
          sql = 'in'
        else
          sql = 'not in'
        end
        # Tested. This is multi-tenant friendly
        find :first, :select => 'rate, increment_in_seconds', :conditions => ['code in (substring(? from 1 for 1),substring(? from 1 for 2),substring(? from 1 for 3),substring(? from 1 for 4),substring(? from 1 for 5),substring(? from 1 for 6),substring(? from 1 for 7)) and call_type ' + sql +  ' (' + CallTypeInfo::CARIBBEAN.to_s + ',' + CallTypeInfo::CARIBBEAN_MOBILE.to_s + ')', number, number, number, number, number, number, number], :order => "length(code) DESC", :limit => 1
    end

  end
  

end