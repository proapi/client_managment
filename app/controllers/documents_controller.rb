class DocumentsController < ApplicationController

  before_filter :authenticate_user!

  # GET /documents
  # GET /documents.json
  def index
    if params[:country_id]
        country = Country.find params[:country_id]
        @documents = country.documents
      else
        @documents = Document.all_cached
      end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    if params[:country_id]
      @country = Country.find params[:country_id]
      @document = @country.documents.build
    else
      @document = Document.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(check_number_with_comma(params[:document]))

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: t('flash.notice') }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(check_number_with_comma(params[:document]))
        format.html { redirect_to @document, notice: t('flash.notice') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url, notice: t('flash.notice') if @document.destroyed? }
      format.json { head :no_content }
    end
  end
end
