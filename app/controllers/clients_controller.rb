class ClientsController < ApplicationController

  before_filter :authenticate_user!

  autocomplete :client, :lastname, :extra_data => [:firstname], :display_value => :fullname

  # GET /clients
  # GET /clients.json
  def index
    #@clients = Client.all_cached

    if params[:client]
      @search = Client.search :lastname_cont => lastname_parser(params[:client][:lastname])
      @clients = @search.result
      params.clear
    else
      @clients = Client.all_cached
    end

    redirect_to @clients.first and return if (@clients.size.eql?(1))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new
    @client.address = Address.new
    @client.mailing_address = Address.new
    @client.user_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/1/history
  def history
    @client = Client.find(params[:id])
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(check_number_with_comma(params[:client]))

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: t('flash.notice') }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(check_number_with_comma(params[:client]))
        format.html { redirect_to @client, notice: t('flash.notice') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url, notice: t('flash.notice') if @clearing.destroyed? }
      format.json { head :no_content }
    end
  end

  private
  def lastname_parser(fullname)
    fullname.split.first
  end
end
