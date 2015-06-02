class BillsReport < Prawn::Document

  require "prawn/measurement_extensions"
  require 'prawn/layout' 
  
  VERTICAL_OFFSET = 279.4 .mm
  HORIZONTAL_OFFSET = 12.9 .mm#(214.9 - 203)
  MAX_AMOUNT_LENGTH = 12
  ROOM_BETWEEN_SECTIONS = 10 .mm
  ROOM_BETWEEN_TITLE_AND_TABLE = 6 .mm
  BOTTOM_MARGIN_FOR_NEW_PAGE = 15 .mm#10 .mm
  VERTICAL_START_OF_NEW_PAGE = 25 .mm
  ROOM_BETWEEN_TITLE_AND_TABLE_FOR_GROUPS = 2 .mm #1 .mm
    
  def default_invoice(bill, site, is_email)
          #Save data into variables
          set_variables(bill, site)
          #Generate the headers
          repeat(lambda { |pg| pg != 1 }) do
            build_default_header
          end
          #Build the front page
          build_default_front_page(is_email)
          #Build recurring charges details
          if @lines.length > 0 or @other_services.length > 0
            build_default_recurring_charges
            @first_section = false
          else
            @first_section = true
          end
          #Build long distance details
          if @calls.length > 0
            build_default_long_distance_details
            @first_section = false
          else
            @first_section = true
          end
          #Build other charges details
          if @adjustments.length > 0
            build_default_adjustments
          end
          #Show page numbering
          build_default_page_numbering
          #Clean up variables
          clear_variables
          #Render the document
          render
          # render_file (bill.account.title + bill.billing_session.name).titleize.gsub(/ /,'') + ".pdf"
  end
  
  def build_default_header
    font_size 8 do
      draw_text "Account Number: " + @account_number, :at => [bounds.right - 50 .mm,VERTICAL_OFFSET - 12 .mm]
      draw_text @site.invoice_number_text + ": " + @invoice_number.to_s, :at => [bounds.right - 50 .mm,VERTICAL_OFFSET - 15 .mm]
      draw_text @site.invoice_date_text + ": " + @billing_date, :at => [bounds.right - 50 .mm,VERTICAL_OFFSET - 18 .mm]
    end 
  end
  
  def build_default_front_page(is_email)
    #============
    #Attach Logos
    #============
    if is_email or @site.show_logo_on_print
      if not @site.logo.nil?
        image  StringIO.new(@site.logo), :at => [7 .mm + 6.mm, VERTICAL_OFFSET - 5 .mm], :width => 45 .mm, :height => 25 .mm #170x95 pixels
      end
      if not @site.logo2.nil?
        image  StringIO.new(@site.logo2), :at => [@site.logo2_x_position .mm , VERTICAL_OFFSET - @site.logo2_y_position .mm], :width => 45 .mm, :height => 25 .mm #170x95 pixels
      end
    end
    #======================
    #Bill Inquiries Section
    #======================
    font_size 8 do
      draw_text @site.bill_inquiries_title, :at => [152.5 .mm - 5.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 12.5 .mm], :style => :bold
      draw_text @site.bill_inquiries_line_1, :at => [152.5 .mm - 5.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 16 .mm]
      if not @site.bill_inquiries_line_2.nil?
        draw_text @site.bill_inquiries_line_2, :at => [152.5 .mm - 5.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 19 .mm]
      end
      if not @site.bill_inquiries_line_3.nil?
        draw_text @site.bill_inquiries_line_3, :at => [152.5 .mm - 5.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 22 .mm]
      end
    end
    #===========================
    #Account # and Dates Section
    #===========================
    font_size 10 do
      draw_text "Account Number", :at => [105 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 30.5 .mm], :style => :bold
      draw_text @account_number, :at => [105 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 34.5 .mm]
      draw_text @site.invoice_number_text, :at => [137.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 30.5 .mm], :style => :bold
      draw_text @invoice_number, :at => [137.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 34.5 .mm]
      draw_text @site.invoice_date_text, :at => [170 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 30.5 .mm], :style => :bold
      draw_text @billing_date, :at => [170 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 34.5 .mm]
      if @site.show_due_date
        draw_text "Payment Due Date:", :at => [120 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 42.5 .mm], :style => :bold
        draw_text @due_date, :at => [155 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 42.5 .mm]
      end
    end
    #============
    #Site Address
    #============
    font_size 8 do
      draw_text @site.address, :at => [7 .mm + 6 .mm,VERTICAL_OFFSET - 32 .mm]
      draw_text @site.city + ", " + @site.province_or_state + " " + @site.postal_or_zip_code + " " + @site.country, :at => [7 .mm + 6 .mm,VERTICAL_OFFSET - 35 .mm]
    end
    #=================================
    #Account Title and Address Section
    #=================================
    font_size 10 do
      draw_text @customer_name, :at => [7 .mm + 6.mm, VERTICAL_OFFSET - (55 .mm + 8 .mm)]
      draw_text @customer_address, :at => [7 .mm + 6.mm, VERTICAL_OFFSET - (59 .mm + 8 .mm)]
      draw_text @customer_city + ", " + @customer_prov_state + "  " + @customer_postal_code, :at => [7 .mm + 6.mm, VERTICAL_OFFSET - (63 .mm+ 8 .mm)]
    end
    #==========================
    #Summary of Charges Section
    #==========================
    font_size 13 do
      draw_text "Summary of Charges", :at => [72 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - 93 .mm], :style => :bold
    end
    #font "Courier"
    #font_size 10 do
    font("Courier", :size => 11) do
      vertical_pos = 104 .mm
      if @total_recurring != 0
        draw_text "Recurring Charges", :at => [39 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos]
        draw_text currencify(@total_recurring).rjust(MAX_AMOUNT_LENGTH), :at => [117.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos]
        vertical_pos += 4 .mm
      end
      if @total_calls != 0
        draw_text "Long Distance Calls", :at => [39 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos]
        draw_text currencify(@total_calls).rjust(MAX_AMOUNT_LENGTH), :at => [117.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos]
        vertical_pos += 4 .mm
      end
      if @total_adjustments != 0
        if @total_adjustments > 0
          draw_text "Other Charges", :at => [39 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos]
        elsif @total_adjustments < 0
          draw_text "Adjustments", :at => [39 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos]
        end
        draw_text currencify(@total_adjustments).rjust(MAX_AMOUNT_LENGTH), :at => [117.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos]
        vertical_pos += 4 .mm
      end
      @taxes.each do |tax|
        draw_text tax.name, :at => [39 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos]
        draw_text currencify(tax.amount_charged).rjust(MAX_AMOUNT_LENGTH), :at => [117.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos]
        vertical_pos += 4 .mm
      end
      draw_text "Total", :at => [39 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos], :style => :bold
      draw_text currencify(@total_after_taxes).rjust(MAX_AMOUNT_LENGTH), :at => [117.5 .mm + HORIZONTAL_OFFSET,VERTICAL_OFFSET - vertical_pos], :style => :bold
      #Clean up
      tax = nil
      vertical_pos = nil
    end
    #===========================
    #Payment Return Slip Section
    #===========================
    # stroke_horizontal_line(0 .mm,215.9 .mm, :at => 53 .mm)
    font_size 9 do
      draw_text @site.invoice_number_text + ":", :at => [5 .mm, 42 .mm]
      draw_text @invoice_number, :at => [35 .mm, 42 .mm] #:at => [31 .mm, 42 .mm]
      draw_text "Account Number:", :at => [5 .mm, 38 .mm]
      draw_text @account_number, :at => [35 .mm, 38 .mm]#[31 .mm, 38 .mm]
      draw_text @site.invoice_slip_title, :at => [70 .mm, 43 .mm], :style => :bold_italic #[90 .mm, 43 .mm], :style => :bold_italic
      if not @site.slip_notes_line_1.nil?
        draw_text @site.slip_notes_line_1, :at => [70 .mm, 37.5 .mm]
      end
      if not @site.slip_notes_line_2.nil?
        draw_text @site.slip_notes_line_2, :at => [70 .mm, 34 .mm]
      end
      if not @site.slip_notes_line_3.nil?
        draw_text @site.slip_notes_line_3, :at => [70 .mm, 30.5 .mm]
      end
      if not @site.slip_notes_line_4.nil?
        draw_text @site.slip_notes_line_4, :at => [70 .mm, 27 .mm]
      end
      if @site.show_amount_due_section
        draw_text "Amount due by", :at => [175 .mm, 46 .mm]
        draw_text @due_date, :at => [175 .mm, 42 .mm]
        draw_text currencify(@total_after_taxes), :at => [175 .mm, 37.5 .mm], :style => :bold
        draw_text "Payment made:", :at => [175 .mm, 32.5 .mm]   
        draw_text @site.currency_symbol + "__________", :at => [175 .mm, 28 .mm]
      end
      draw_text @site.name, :at => [5 .mm, 11 .mm]
      draw_text @site.address, :at => [5 .mm, 8 .mm]
      draw_text @site.city + ", " + @site.province_or_state + " " + @site.postal_or_zip_code + " " + @site.country, :at => [5 .mm, 5 .mm]
    end
    font_size 8 do
      draw_text @customer_name, :at => [5 .mm, 31 .mm], :style => :bold
    end
    
  end
  
  def build_default_recurring_charges
    #===========
    #Build Title
    #===========
    build_section_title(:recurring)
    #==============================
    #Build a multi page table
    #============================== 
    build_multipage_table(:recurring, @lines, @other_services)
  end
  
  def build_default_long_distance_details
    #======================
    #Group by phone # first
    #======================
    build_section_title(:long_distance, :phone_number)
    calls_sorted = @calls.sort_by {|a| [a.orig_tn, a.id]} #sort by phone_number
    # calls_sorted = @calls.sort_by {|a| [a.orig_tn, a.date, a.time]} #sort by phone_number <-- This was only for Comtel since they had multiple providers
    calls_grouped = calls_sorted.group_by {|n| n.orig_tn}
    calls_grouped.each do |n, calls|
      if y.to_i <= BOTTOM_MARGIN_FOR_NEW_PAGE
        insert_page_break(true)
        move_cursor_to(y - VERTICAL_START_OF_NEW_PAGE)     
      end
      font_size 8 do
        draw_text @site.number_group_by_text + ": " + n.to_s, :at => [bounds.left + 15 .mm, y], :style => :bold
      end
      move_cursor_to(y - ROOM_BETWEEN_TITLE_AND_TABLE_FOR_GROUPS)
      build_multipage_table(:long_distance, calls, nil, nil)
      move_cursor_to(y - ROOM_BETWEEN_TITLE_AND_TABLE_FOR_GROUPS - 1 .mm)    
    end
    #=================
    #Summary by number
    #=================
    font_size 8 do
      draw_text "Summary of charges by " + @site.number_group_by_text.downcase, :at => [bounds.left + 15 .mm, y], :style => :bold
    end
    move_cursor_to(y - ROOM_BETWEEN_TITLE_AND_TABLE_FOR_GROUPS)
    build_multipage_table(:long_distance_summary, nil, nil, calls_grouped)
    #=======================
    #Group by code if needed
    #=======================
    if @calls.detect {|call| not call.code.blank?}
    # if @calls.detect {|call| call.code.length > 0}
      build_section_title(:long_distance, :code)
      calls_sorted = @calls.sort_by {|a| [a.code, a.id]} #sort by phone_number
      calls_grouped = calls_sorted.group_by {|n| n.code}
      calls_grouped.each do |n, calls|
        if y.to_i <= BOTTOM_MARGIN_FOR_NEW_PAGE
          insert_page_break(true)
          move_cursor_to(y - VERTICAL_START_OF_NEW_PAGE)     
        end
        font_size 8 do
          draw_text "Account Code: " + n.to_s, :at => [bounds.left + 15 .mm, y], :style => :bold
        end
        move_cursor_to(y - ROOM_BETWEEN_TITLE_AND_TABLE_FOR_GROUPS)
        build_multipage_table(:long_distance, calls, nil, nil)
        move_cursor_to(y - ROOM_BETWEEN_TITLE_AND_TABLE_FOR_GROUPS - 1 .mm)    
      end 
      #===============
      #Summary by code
      #===============
      font_size 8 do
        draw_text "Summary of charges by account code", :at => [bounds.left + 15 .mm, y], :style => :bold
      end
      move_cursor_to(y - ROOM_BETWEEN_TITLE_AND_TABLE_FOR_GROUPS)
      build_multipage_table(:long_distance_summary, nil, nil, calls_grouped)     
    end
    #========
    #Clean up
    #========
    calls_grouped = nil
    calls_sorted = nil
  end
  
  def build_default_adjustments
    #===========
    #Build Title
    #===========
    build_section_title(:adjustments)
    #==============================
    #Build a multi page table
    #============================== 
    build_multipage_table(:adjustments, @adjustments)    
  end
  
  def build_section_title(type, group_by = nil)
    #===================
    #Get the start point
    #===================
    if @first_section == true or y <= BOTTOM_MARGIN_FOR_NEW_PAGE or type == :recurring
      insert_page_break(true)
      start_point = y - VERTICAL_START_OF_NEW_PAGE
    else
      start_point = y - ROOM_BETWEEN_SECTIONS
    end 
    #=====
    #Title
    #=====
    title = case type
      when :recurring
        "Recurring Charges Details"
      when :adjustments
        "Other Charges"
      when :long_distance
        case group_by
          when :phone_number
            "Long Distance Details (by " + @site.number_group_by_text + ")"
          when :code
            "Long Distance Details (by Account Code)"
        end
    end
    font_size 10 do
      draw_text title, :at => [bounds.left + 10 .mm, start_point], :style => :bold
    end
    move_cursor_to(start_point - ROOM_BETWEEN_TITLE_AND_TABLE)
    #========
    #Clean up
    #========
    title = nil    
  end
  
  def build_multipage_table(type, array1, array2 = nil, summary_array = nil)
      #================
      #Initialize stuff
      #================
      table_line = 0
      table_lines = get_max_table_lines
      data = []
      #==========================
      #Build the multi page table
      #==========================
      if array1 != nil
        array1.each do |item|
          case type
            when :recurring
              if item.amount_charged != 0 and not item.amount_charged.nil?
                description = ""
                if not item.type_of_line.nil?
                  description = item.type_of_line
                end
                if not item.use.nil?
                  if not description.blank?
                    description = description + ". " + item.use
                  else
                    description = item.use
                  end
                end
                data << [item.number, description, currencify(item.amount_charged)]
                table_line = table_line + 1
              end
            when :long_distance
              #Show only if there is an amount to charge (won't show free calls!)
              if item.amount_charged != 0 and not item.amount_charged.nil?
                #First build the destination based on destination and prov/state fields
                destination = ""
                if not item.destination.nil?
                  if item.dest_prov_state.nil?
                    destination = item.destination
                  else
                    destination = item.destination + " " + item.dest_prov_state 
                  end
                end
                #Now pass the data
                data << [item.date, item.time, item.orig_tn, item.term_tn, destination, Time.at(item.duration_sec).utc.strftime("%H:%M:%S"), currencify(item.amount_charged)]
                table_line = table_line + 1
              end
            when :adjustments
              data << [item.description, currencify(item.amount_charged)]
              table_line = table_line + 1
          end
          if table_line >= table_lines
            build_table(data, true, type)
            table_lines = get_max_table_lines
            table_line = 0
            data = []
          end   
        end
      end
      if array2 != nil
        if type == :recurring
          array2.each do |item|
            if item.amount_charged != 0 and not item.amount_charged.nil?
              data << [item.type_of_service, item.use,  currencify(item.amount_charged)]
              table_line = table_line + 1
              if table_line >= table_lines
                build_table(data, true, :recurring)
                table_lines = get_max_table_lines
                table_line = 0
                data = []
              end
            end     
          end
        end
      end
      if summary_array != nil and type == :long_distance_summary
        summary_array.each do |n, items|
          data << [n.to_s, currencify(items.sum { |p| p.amount_charged})]
          table_line = table_line + 1
          if table_line >= table_lines
            build_table(data, true, :long_distance_summary)
            table_lines = get_max_table_lines
            table_line = 0
            data = []
          end
        end
      end
      case type
        when :recurring
          data << ["","Total:", currencify(@total_recurring)]
        when :long_distance
          data << ["", "", "", "", "", "Total:", currencify(array1.sum { |p| p.amount_charged})]
        when :long_distance_summary
          data << ["Total:", currencify(@total_calls)]
        when :adjustments
          data << ["Total:", currencify(@total_adjustments)]
      end
      build_table(data, false, type)
      #========
      #Clean up
      #========
      table_line = nil
      table_lines = nil
      data = nil
      description = nil
      item = nil
  end

  def get_max_table_lines
      ((y - BOTTOM_MARGIN_FOR_NEW_PAGE)/9).to_i
  end
  
  def build_table(data, page_break, type)
    case type
      when :recurring
        headers = ["Item", "Description", @site.charge_title]
        align = { 0 => :left, 1 => :left, 2 => :right}
      when :long_distance
        headers = ["Date", "Time", @site.billed_number_title, @site.to_from_number_title, @site.to_from_title, @site.duration_title, @site.charge_title]
        align = { 0 => :left, 1 => :left, 2 => :left, 3 => :left, 4 => :left, 5 => :left,  6 => :right}
      when :long_distance_summary
        headers = ["", @site.charge_title]
        align = { 0 => :left, 1 => :right} 
      when :adjustments
        headers = ["Description", @site.charge_title]
        align = { 0 => :left, 1 => :right}
    end
    font("Courier", :size => 8) do
      table data,           :headers            => headers,
                            :width              => 525,
                            :font_size          => 8,
                            :vertical_padding   => 0,
                            :horizontal_padding => 5,
                            :position           => :center,
                            :row_colors         => :pdf_writer,
                            :border_width       => 0,
                            :align              => align 
    end
    if page_break == true
      insert_page_break(true)
      move_cursor_to(y - VERTICAL_START_OF_NEW_PAGE)
    end
    headers = nil
    align = nil  
  end
      
  def build_default_page_numbering
    font_size 8 do
      number_pages "Page <page> of <total>", [bounds.right - 25 .mm, VERTICAL_OFFSET - 6 .mm]
    end 
  end
  
  def set_variables(bill, site)
    @first_section = true
    @invoice_number = bill.number
    @account_number = bill.account.account_number.upcase
    @customer_name = bill.account.title.upcase
    @customer_address = bill.account.address.upcase
    @customer_city = bill.account.city.upcase
    @customer_prov_state = bill.account.province_or_state.upcase
    @customer_postal_code = bill.account.zip_or_postal_code.upcase
    @due_date = bill.billing_session.due_date.strftime("%e %b, %Y")
    @billing_date = bill.billing_session.billing_date.strftime("%e %b, %Y")
    @total_adjustments = bill.billed_adjustments.sum(:amount_charged)
    @total_calls = bill.billed_calls.sum(:amount_charged)
    @total_recurring = bill.billed_lines.sum(:amount_charged) + bill.billed_services.sum(:amount_charged)
    @total_before_taxes = @total_adjustments + @total_calls + @total_recurring
    @total_after_taxes = @total_before_taxes + bill.billed_taxes.sum(:amount_charged)
    @taxes = bill.billed_taxes
    @lines = bill.billed_lines
    @other_services = bill.billed_services
    @calls = bill.billed_calls
    @adjustments = bill.billed_adjustments
    @site = site
  end
  
  def clear_variables
    @invoice_number = nil
    @account_number = nil
    @customer_name = nil
    @customer_city = nil
    @customer_prov_state = nil
    @customer_postal_code = nil
    @due_date = nil
    @billing_date = nil
    @total_adjustments = nil
    @total_calls = nil
    @total_recurring = nil
    @total_before_taxes = nil
    @total_after_taxes = nil
    @taxes = nil
    @lines = nil
    @other_services = nil
    @calls = nil
    @first_section = nil
    @adjustments = nil
    @site = nil
  end

  def insert_page_break(set_start_point)
    start_new_page(:margin => 0)
    if set_start_point == true
      start_point = VERTICAL_OFFSET - VERTICAL_START_OF_NEW_PAGE
    end   
  end
  
  def currencify(number, options={})
    if number != 0 and not number.nil?
      # :currency_before => false puts the currency symbol after the number
      # default format: $12,345,678.90
      options = {:currency_symbol => @site.currency_symbol, :delimiter => ",", :decimal_symbol => ".", :currency_before => true}.merge(options)
      # split integer and fractional parts 
      int, frac = ("%.#{@site.decimals}f" % number).split('.')
      # insert the delimiters
      int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")

      if options[:currency_before]
        options[:currency_symbol] + int + options[:decimal_symbol] + frac
      else
        int + options[:decimal_symbol] + frac + options[:currency_symbol]
      end
    else
      @site.currency_symbol + ("%.#{@site.decimals}f" % 0.00)
    end
    
  end
    
end