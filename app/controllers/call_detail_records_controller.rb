class CallDetailRecordsController < ApplicationController
  # GET /call_detail_records
  # GET /call_detail_records.json
  def index
    @uploader = CallDetailRecord.new.cdr
    @uploader.success_action_redirect = new_call_detail_record_url

    @call_detail_records = CallDetailRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @call_detail_records }
    end
  end

  # GET /call_detail_records/1
  # GET /call_detail_records/1.json
  def show
    @call_detail_record = CallDetailRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @call_detail_record }
    end
  end

  # GET /call_detail_records/new
  # GET /call_detail_records/new.json
  def new
    # @call_detail_record = CallDetailRecord.new
    @call_detail_record = CallDetailRecord.new(key: params[:key])
    # @call_detail_record.update_attribute :storage_path, params[:key]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @call_detail_record }
    end
  end

  # GET /call_detail_records/1/edit
  def edit
    @call_detail_record = CallDetailRecord.find(params[:id])
  end

  # POST /call_detail_records
  # POST /call_detail_records.json
  def create
    @call_detail_record = CallDetailRecord.new(params[:call_detail_record])

    respond_to do |format|
      if @call_detail_record.save
        format.html { redirect_to call_detail_records_url, notice: 'Call detail record was successfully uploaded.' }
        format.json { render json: @call_detail_record, status: :created, location: @call_detail_record }
      else
        format.html { render action: "new" }
        format.json { render json: @call_detail_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /call_detail_records/1
  # PUT /call_detail_records/1.json
  def update
    @call_detail_record = CallDetailRecord.find(params[:id])

    respond_to do |format|
      if @call_detail_record.update_attributes(params[:call_detail_record])
        format.html { redirect_to @call_detail_record, notice: 'Call detail record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @call_detail_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /call_detail_records/1
  # DELETE /call_detail_records/1.json
  def destroy
    @call_detail_record = CallDetailRecord.find(params[:id])
    @call_detail_record.destroy

    respond_to do |format|
      format.html { redirect_to call_detail_records_url }
      format.json { head :no_content }
    end
  end
end
