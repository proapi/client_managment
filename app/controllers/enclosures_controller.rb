class EnclosuresController < ApplicationController

  before_filter :authenticate_user!

  # GET /enclosures
  # GET /enclosures.json
  def index
    if params[:clearing_id]
      clearing = Clearing.find params[:clearing_id]
      @enclosures = clearing.enclosures
    else
      @enclosures = Enclosure.all_cached
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @enclosures }
    end
  end

  # GET /enclosures/1
  # GET /enclosures/1.json
  def show
    @enclosure = Enclosure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @enclosure }
    end
  end

  # GET /enclosures/new
  # GET /enclosures/new.json
  def new
    if params[:clearing_id]
      @clearing = Clearing.find(params[:clearing_id])
      @enclosure = @clearing.enclosures.build
    else
      @enclosure = Enclosure.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @enclosure }
    end
  end

  # GET /enclosures/1/edit
  def edit
    @enclosure = Enclosure.find(params[:id])
  end

  # POST /enclosures
  # POST /enclosures.json
  def create
    @enclosure = Enclosure.new(params[:enclosure])
    @enclosure.user_id = current_user.id

    respond_to do |format|
      if @enclosure.save
        format.html { redirect_to @enclosure, notice: t('flash.notice')}
        format.json { render json: @enclosure, status: :created, location: @enclosure }
      else
        format.html { render action: "new" }
        format.json { render json: @enclosure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /enclosures/1
  # PUT /enclosures/1.json
  def update
    @enclosure = Enclosure.find(params[:id])

    respond_to do |format|
      if @enclosure.update_attributes(params[:enclosure])
        format.html { redirect_to @enclosure, notice: t('flash.notice')}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @enclosure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enclosures/1
  # DELETE /enclosures/1.json
  def destroy
    @enclosure = Enclosure.find(params[:id])
    @enclosure.destroy

    respond_to do |format|
      format.html { redirect_to enclosures_url }
      format.json { head :no_content }
    end
  end
end
