class NewslettersController < ApplicationController
  before_action :set_newsletter, only: [:show, :edit, :update, :destroy, :preview]
  filter_resource_access

  SAVE = "Save"
  PUBLISH = "Publish"

  # GET /newsletters
  # GET /newsletters.json
  def index
    @newsletters = Newsletter.all
  end

  # GET /newsletters/1
  # GET /newsletters/1.json
  def show
  end

  def new
    @newsletter = Newsletter.new
  end

  def create
    @newsletter = Newsletter.new(newsletter_params)
    respond_to do |format|
      if @newsletter.save
        format.html { redirect_to edit_newsletter_path(@newsletter), notice: 'Newsletter was successfully created.' }
        format.json { render :show, status: :created, location: @newsletter }
      else
        format.html { render :new }
        format.json { render json: @newsletter.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /newsletters/1/edit
  def edit
  end

  # PATCH/PUT /newsletters/1
  # PATCH/PUT /newsletters/1.json
  def update
    respond_to do |format|
      ns_params = params["newsletter"]
      ns_params["articles_attributes"] = ns_params["articles_attributes"].select {|art_attr| ns_params["article_ids"].include?(art_attr["id"])}
      ns_params.merge!(status: Newsletter::Status::PUBLISHED) if params[:commit] == PUBLISH
      if @newsletter.update(newsletter_params)
        NewsletterMailer.send_mail(@newsletter).deliver_later if params[:commit] == PUBLISH
        format.html { redirect_to newsletters_path, notice: "Newsletter #{params[:commit].downcase} was successful." }
        format.json { render :show, status: :ok, location: @newsletter }
      else
        format.html { render :edit }
        format.json { render json: @newsletter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /newsletters/1
  # DELETE /newsletters/1.json
  def destroy
    @newsletter.destroy
    respond_to do |format|
      format.html { redirect_to newsletters_url, notice: 'Newsletter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def preview
    render layout: false
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_newsletter
    @newsletter = Newsletter.find(params[:id])
  end

  def new_newsletter_from_params
    @newsletter = params[:newsletter] ? Newsletter.new(newsletter_params) : Newsletter.new
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def newsletter_params
    params.require(:newsletter).permit(:name, :status, article_ids: [],
                                       category_newsletters_attributes: [:id, :newsletter_id, :category_id, :position_in_newsletter],
                                       articles_attributes: [:id, :position_in_newsletter])
  end
end
