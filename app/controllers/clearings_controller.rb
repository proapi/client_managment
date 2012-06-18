class ClearingsController < ApplicationController
  # GET /clearings
  # GET /clearings.json
  def index
    if params[:client_id]
      client = Client.find params[:client_id]
      @clearings = client.clearings
    else
      @clearings = Clearing.all_cached
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clearings }
    end
  end

  # GET /clearings/1
  # GET /clearings/1.json
  def show
    @clearing = Clearing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @clearing }
    end
  end

  # GET /clearings/new
  # GET /clearings/new.json
  def new
    if params[:client_id]
      @client = Client.find(params[:client_id])
      @clearing = @client.clearings.build
    else
      @clearing = Clearing.new
    end
    @user = current_user
    @user.clearings << @clearing

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @clearing }
    end
  end

  # GET /clearings/1/edit
  def edit
    @clearing = Clearing.find(params[:id])
  end

  # POST /clearings
  # POST /clearings.json
  def create
    @clearing = Clearing.new(params[:clearing])

    respond_to do |format|
      if @clearing.save
        format.html { redirect_to @clearing, notice: 'Clearing was successfully created.' }
        format.json { render json: @clearing, status: :created, location: @clearing }
      else
        format.html { render action: "new" }
        format.json { render json: @clearing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clearings/1
  # PUT /clearings/1.json
  def update
    @clearing = Clearing.find(params[:id])

    respond_to do |format|
      if @clearing.update_attributes(params[:clearing])
        format.html { redirect_to @clearing, notice: 'Clearing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @clearing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clearings/1
  # DELETE /clearings/1.json
  def destroy
    @clearing = Clearing.find(params[:id])
    @clearing.destroy

    respond_to do |format|
      format.html { redirect_to clearings_url }
      format.json { head :no_content }
    end
  end
end
