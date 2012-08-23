class BillsController < ApplicationController

  before_filter :authenticate_user!

  # GET /bills
  # GET /bills.json
  def index
    @bills = Bill.all_cached

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bills }
    end
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
    @bill = Bill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bill }
      format.pdf do
        file = @bill.to_pdf
        send_file file, :filename => "rachunek_#{l Date.current}.pdf", :type => "application/pdf"
      end
    end
  end

  # GET /bills/new
  # GET /bills/new.json
  def new
    if params[:clearing_id]
      @clearing = Clearing.find(params[:clearing_id])
      @bill = @clearing.build_bill
      @bill.total = @clearing.commission_final unless @clearing.commission_final.nil?
      @bill.issue_date = Date.today
    else
      @bill = Bill.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bill }
    end
  end

  # GET /bills/1/edit
  def edit
    @bill = Bill.find(params[:id])
  end

  # POST /bills
  # POST /bills.json
  def create
    @bill = Bill.new(check_number_with_comma(params[:bill]))
    @bill.user_id = current_user.id

    respond_to do |format|
      if @bill.save
        format.html { redirect_to @bill, notice: t('flash.notice') }
        format.json { render json: @bill, status: :created, location: @bill }
      else
        format.html { render action: "new" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bills/1
  # PUT /bills/1.json
  def update
    @bill = Bill.find(params[:id])

    respond_to do |format|
      if @bill.update_attributes(check_number_with_comma(params[:bill]))
        format.html { redirect_to @bill, notice: t('flash.notice') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill = Bill.find(params[:id])
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to bills_url, notice: t('flash.notice') if @bill.destroyed? }
      format.json { head :no_content }
    end
  end
end
