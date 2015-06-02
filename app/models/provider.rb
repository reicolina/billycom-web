class Provider < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :name, :has_header, :orig_tn, :date, :date_contains_time, :time, :duration_sec, :convert_from_minutes, :destination, :destination1, :destination_prov_state, :destination_prov_state1, :cc_ind, :ovs_ind, :ovs_ind2, :default_call_type, :term_tn, :term_tn1, :code, :provider_charge, :prefixes, :call_type_abbreviation, :prefixes1, :call_type_abbreviation1
  belongs_to :site
  has_many :call_detail_records, :dependent => :destroy
  validates_presence_of :name
  validates_presence_of :orig_tn
  validates_presence_of :date
  validates_presence_of :duration_sec
  validates_presence_of :ovs_ind, :if => :ovs_ind2?, :message => "- International call indicator 1 can't be blank if there is an international call indicator 2."
  validates_presence_of :term_tn
  validates_presence_of :provider_charge
  validates_presence_of :default_call_type, :if => :not_ovs_ind?, :message => "has to be selected if there is no international call indicator."
  validates_uniqueness_to_tenant :name
  
  require 'csv'

  def import_cdr(data)
    # provider = Provider.find(provider_id)
    ActsAsTenant.with_tenant(self.site) do
      self.import_usage(CSV.parse(data, :headers => self.has_header))
    end
  end
  # handle_asynchronously :import_cdr, :queue => 'billing', :priority => 0

  def not_ovs_ind?
    ovs_ind.nil?
  end
  
  def ovs_ind2?
    not ovs_ind2.nil?
  end

  def import_usage(parsed_file)
    # absolute_path = "#{Rails.root}/tmp/"
    # csv_string = CSV.generate do |csv|
    n=0 
    csv = []
    isCustomFlowUnitedCloud = ActsAsTenant.current_tenant.name.include? 'UnitedCloud'
    if isCustomFlowUnitedCloud
      Rails.logger.info "CUSTOM_FLOW: Running custom flow for UnitedCloud"
    end
    parsed_file.each  do |row|
      #Check that the orig_tn is populated, otherwise skip it (it might be a header or something like that)
      if (not row[self.orig_tn-1].nil?) && (row[self.orig_tn-1].length > 0)   
        # set the originating number and remove invalid characters
        if isCustomFlowUnitedCloud && (row[self.ovs_ind-1] == '10.2.12.16')
          # UnitedCloud toll free call
          orig_number = get_term_tn(row)
        else
          orig_number = row[self.orig_tn-1]
        end
        if orig_number[0] == '_'
          orig_number[0] = ''
        end
        # for unitedcloud: append a 1 to the orig tn if needed
        if (isCustomFlowUnitedCloud && orig_number.size == 10 && orig_number[0] != '1')
          orig_number = '1'.to_s + orig_number.to_s
        end
        #check for cc_ind
        if self.cc_ind.nil?
          calling_card_ind = nil
        else
          calling_card_ind = row[self.cc_ind-1]
        end     
        #Check for code
        if self.code.nil?
          code = nil
        else
          if row[self.code-1].nil?
            code = nil
          elsif row[self.code-1].length > 0
              code = row[self.code-1]
          else
            code = nil
          end
        end
        #Check for time
        if self.time.nil? || self.date_contains_time?
          #Check if the time is included within the date field
          if self.date_contains_time?
            time = row[self.date-1].split(" ", 2).at(1)
            if not time.nil?
              time = time.gsub(" a.m.","am").gsub(" p.m.","pm")
            else
              time = nil
            end
          else
            time = nil
          end
        else
          time = row[self.time-1].gsub("1/01/1900 ","").gsub(" a.m.","am").gsub(" p.m.","pm")
        end
        #Check for date (eventhough it is required)
        if self.date_contains_time?
          date = row[self.date-1].split(" ", 2).at(0)
        else
          date = row[self.date-1].gsub(" 12:00:00 a.m.","")
        end
        #Check for destination
        if self.destination.nil?
          destination = nil
        else
          destination = get_destination(row)
        end
        #Check for Prov/State
        if self.destination_prov_state.nil?
          dest_prov_state = nil
        else
          dest_prov_state = get_prov_state(row)
        end
        #Check for ovs_ind2
        if not isCustomFlowUnitedCloud
          if self.ovs_ind2.nil?
            if self.ovs_ind.nil?
              international_call_type = self.default_call_type
            else
              international_call_type = row[self.ovs_ind-1]
            end
          else
            if row[self.ovs_ind2-1].nil?
              international_call_type = row[self.ovs_ind-1]
            else
              international_call_type = row[self.ovs_ind-1] + " " + row[self.ovs_ind2-1]
            end
          end
          #Overwrite international_call_type if prefixes are set up
          if has_prefix(orig_number, self.prefixes)
            if (not self.call_type_abbreviation.nil?) && (self.call_type_abbreviation.length > 0)
              international_call_type = self.call_type_abbreviation
            end
          end
          if has_prefix(orig_number, self.prefixes1)
            if (not self.call_type_abbreviation1.nil?) && (self.call_type_abbreviation1.length > 0)
              international_call_type = self.call_type_abbreviation1
            end
          end
        else
          # unitedCloud custom flow
          destination_number = get_term_tn(row)
          canada = ['403','587','780','250','778','236','604','204','431','506','709','902','762','416','647','437','519','226','613','343','705','249','807','905','289','365','902','762','418','581''450','579''514','438''819','873']
          caribbean = ['264','268','242','246','441','284','345','767','809','829','849','473','876','664','787','939','869','758','784','721','868','649','340','684','671','670']
          area_code = ''
          # get the area code
          if get_term_tn(row)[0] == '1'
            area_code = get_term_tn(row)[1.3]
          else
            area_code = get_term_tn(row)[0.2]
          end
          # determine the call type
          if (row[self.provider_charge-1] == 0) || (row[self.ovs_ind-1] == '10.2.12.120')
            #free call
            international_call_type = 'free'
          elsif (row[self.ovs_ind-1] == '10.2.12.16')
            # tollfree
            international_call_type = 'tollfree'
          elsif destination_number.size > 11
            # overseas
            international_call_type = 'overseas'
          elsif canada.include? area_code
            # canada
            international_call_type = 'canada'
          elsif caribbean.include? area_code
            # caribbean
            international_call_type = 'caribbean'
          else
            # usa
            international_call_type = 'usa'
          end
          destination_number = nil
          area_code = nil
          canada = nil
          caribbean = nil
        end
        #Check for a currency symbol within the provider's charge
        if not is_numeric((row[self.provider_charge-1])[0].chr)
          row[self.provider_charge-1].slice!(0)         
        end
        charge = row[self.provider_charge-1]
        if (charge.nil?) || (charge == '')
          charge = 0
        end
        if row[self.duration_sec-1].to_s.include? ":"
          #convert to seconds from HH:mm:ss
          duration = row[self.duration_sec-1].split(':').inject(0){|a, m| a = a * 60 + m.to_i}
        else
          #Convert duration to seconds if necessary
          if self.convert_from_minutes?
            duration = (row[self.duration_sec-1].to_f * 60).to_i
          else
            duration = row[self.duration_sec-1]
          end
        end
        if (duration.nil?) || (duration == '')
          duration = 0
        end
        
        # TempCall.create!(:orig_tn => row[self.orig_tn-1], :date => date, :time => time, :duration_sec => duration, :destination => destination, :dest_prov_state => dest_prov_state, :cc_ind => calling_card_ind, :ovs_ind => international_call_type, :term_tn => get_term_tn(row), :code => code, :provider_charge => charge.gsub(",",""), :provider_id => self.id)

        #Build the array
        if isCustomFlowUnitedCloud && (row[self.ovs_ind-1] == '10.2.12.16')
          # united cloud custom flow toll free: use orig as dest #
          csv.push "(" + [ActiveRecord::Base.connection.quote(orig_number),ActiveRecord::Base.connection.quote(date),ActiveRecord::Base.connection.quote(time),duration,ActiveRecord::Base.connection.quote(destination),ActiveRecord::Base.connection.quote(dest_prov_state),ActiveRecord::Base.connection.quote(calling_card_ind),ActiveRecord::Base.connection.quote(international_call_type),ActiveRecord::Base.connection.quote(row[self.orig_tn-1]),ActiveRecord::Base.connection.quote(code),charge.gsub(",",""),self.id,ActsAsTenant.current_tenant.id].join(", ") + ")"
        else
          csv.push "(" + [ActiveRecord::Base.connection.quote(orig_number),ActiveRecord::Base.connection.quote(date),ActiveRecord::Base.connection.quote(time),duration,ActiveRecord::Base.connection.quote(destination),ActiveRecord::Base.connection.quote(dest_prov_state),ActiveRecord::Base.connection.quote(calling_card_ind),ActiveRecord::Base.connection.quote(international_call_type),ActiveRecord::Base.connection.quote(get_term_tn(row)),ActiveRecord::Base.connection.quote(code),charge.gsub(",",""),self.id,ActsAsTenant.current_tenant.id].join(", ") + ")"
        end
        n=n+1
        if n%Source::Application.config.gc_start_loop_count==0
          Rails.logger.info "LOOP_COUNT: [import_usage] " + n.to_s + " loops"
          sql = "INSERT INTO temp_calls (orig_tn, date, time, duration_sec, destination, dest_prov_state, cc_ind, ovs_ind, term_tn, code, provider_charge,provider_id, site_id) VALUES #{csv.join(", ")}".force_encoding("UTF-8")
          Rails.logger.info "INFO: [import_usage] executing insert query for these " + Source::Application.config.gc_start_loop_count.to_s + " items"
          ActiveRecord::Base.connection.execute(sql)
          csv = []
          # GC.start
        end
      end
    end
    # end
    if (not csv.nil?) && (csv.length > 0)
      sql = "INSERT INTO temp_calls (orig_tn, date, time, duration_sec, destination, dest_prov_state, cc_ind, ovs_ind, term_tn, code, provider_charge,provider_id, site_id) VALUES #{csv.join(", ")}".force_encoding("UTF-8")
      Rails.logger.info "INFO: [import_usage] executing insert query for the rest of the items left"
      ActiveRecord::Base.connection.execute(sql)
    end
    destination = nil
    date = nil
    time = nil
    code = nil
    charge = nil
    calling_card_ind = nil
    international_call_type = nil
    duration = nil
    orig_number = nil
    parsed_file = nil
    csv = nil
    sql = nil
    Rails.logger.info "MEMORY_MANAGEMENT: [import_usage] starting garbage collector after mass inserts"
    GC.start

    # tmp_file = absolute_path + 'import.tmp'
    # File.open(tmp_file, 'w') {|f| f.write(csv_string) }
    # ActiveRecord::Base.connection.execute(load_data_infile(tmp_file))
    # system("rm", tmp_file) # remove the temp file  
  end
  
  def has_prefix(number, prefixes_string)
    if (not prefixes_string.nil?) && (prefixes_string.length > 0)
      prefixes = prefixes_string.split(",").collect(&:strip)
      prefixes.each do |prefix|
        exists = number.start_with? prefix
        return exists if exists == true
      end
    else
      return false
    end
    return false
  end
  
  def get_term_tn(row)
    if not self.term_tn.nil?
      destination_number = row[self.term_tn-1]
      if (not destination_number.nil?) && (destination_number.length > 0)
        if destination_number[0] == '_'
          destination_number[0] = ''
        end   
      end
    end
    if not self.term_tn1.nil?
      destination_number1 = row[self.term_tn1-1]
      if (not destination_number1.nil?) && (destination_number1.length > 0)
        if destination_number1[0] == '_'
          destination_number1[0] = ''
        end  
      end
    end
    if destination_number.nil? #if there is nothing in the destination field, try the alternative one
      if self.term_tn1.nil?
        nil
      else
        if destination_number1.gsub(/[^0-9]/,"").length > 0
          destination_number1
        else
          nil
        end
      end
    else
      if destination_number.gsub(/[^0-9]/,"").length > 0
        destination_number
      else
        if self.term_tn1.nil?
          nil
        else
          if destination_number1.gsub(/[^0-9]/,"").length > 0
            destination_number1
          else
            nil
          end
        end
      end
    end
  end
    
  def get_destination(row)
    if row[self.destination-1].nil? #if there is nothing in the destination field, try the alternative one
      if self.destination1.nil?
        nil
      else
        if row[self.destination1-1].length > 0
          row[self.destination1-1].gsub(",","")
        else
          nil
        end
      end
    else
      if row[self.destination-1].length > 0
        row[self.destination-1].gsub(",","")
      else
        if self.destination1.nil?
          nil
        else
          if row[self.destination1-1].length > 0
            row[self.destination1-1].gsub(",","")
          else
            nil
          end
        end
      end
    end
  end
  
  def get_prov_state(row)
    if row[self.destination_prov_state-1].nil? #if there is nothing in the prov/state field, try the alternative one
      if self.destination_prov_state1.nil?
        nil
      else
        row[self.destination_prov_state1-1]
      end
    else
      if row[self.destination_prov_state-1].length > 0
        row[self.destination_prov_state-1]
      else
        if self.destination_prov_state1.nil?
          nil
        else
          row[self.destination_prov_state1-1]
        end
      end
    end 
  end
  
end

# def load_data_infile(temp_path)
#            <<-EOF
#                  LOAD DATA INFILE "#{temp_path}" 
#                           INTO TABLE temp_calls
#                           FIELDS TERMINATED BY ','
#                              (orig_tn, date, time, duration_sec, destination, dest_prov_state, cc_ind, ovs_ind, term_tn, code, provider_charge,provider_id)
#                             SET created_at = '#{Time.current.to_s(:db)}',
#                             updated_at = '#{Time.current.to_s(:db)}',
#                             site_id = '#{ActsAsTenant.current_tenant.id}';
#             EOF
# end

def is_numeric(character)
   true if Integer(character) rescue false
end