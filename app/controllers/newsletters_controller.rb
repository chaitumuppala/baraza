class NewslettersController < ApplicationController
  before_action :set_newsletter, only: [:show, :edit, :update, :destroy]
  before_action :new_newsletter_from_params, only: [:new, :create]

  filter_resource_access additional_collection: [:subscribe]

  SAVE = 'Save'
  PREVIEW = 'Preview'
  PUBLISH = 'Publish'

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
  end

  def create
    respond_to do |format|
      if @newsletter.save
        format.html { redirect_to edit_newsletter_path(@newsletter), notice: 'eMagazine was successfully created.' }
        format.json { render :show, status: :created, location: @newsletter }
      else
        format.html { render :new }
        format.json { render json: @newsletter.errors.full_messages.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  # GET /newsletters/1/edit
  def edit
  end

  # PATCH/PUT /newsletters/1
  # PATCH/PUT /newsletters/1.json
  def update
    ns_params = params[:newsletter]
    unless Subscriber.exists?
      flash.now[:alert] = 'There are no subscribers'
      render(:edit)
      return
    end
    if ns_params['article_ids'].blank?
      flash.now[:alert] = 'Select at least one article'
      render(:edit)
      return
    end
    ns_params['articles_attributes'] = ns_params['articles_attributes'].select { |art_attr| ns_params['article_ids'].include?(art_attr['id']) }
    ns_params.merge!(status: Newsletter::Status::PUBLISHED) if params[:commit] == PUBLISH
    if @newsletter.update(newsletter_params)
      if params[:commit] == PUBLISH
        # TODO: Vijay: Move to an after_save hook on model
        NewsletterMailer.send_mail(@newsletter).deliver_now
        flash[:notice] = 'eMagazine was successfully sent out to the subscribers'
        redirect_to newsletters_path
      elsif params[:commit] == SAVE
        flash[:notice] = 'eMagazine is saved successfully'
        redirect_to edit_newsletter_path(@newsletter)
      elsif params[:commit] == PREVIEW
        render 'newsletters/preview', layout: false
      end
    else
      render :edit
    end
  end

  def subscribe
    subscriber = Subscriber.new(email: params[:email])
    if subscriber.save
      NewsletterMailer.subscription_signup(params[:email])
      flash[:notice] = 'Subscribed successfully'
    else
      flash[:alert] = subscriber.errors.full_messages.join('<br/>')
    end
    redirect_to root_path
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
    params.require(:newsletter).permit(:name, :status, article_ids:                     [],
                                                       category_newsletters_attributes: [:id, :newsletter_id, :category_id, :position_in_newsletter],
                                                       articles_attributes:             [:id, :position_in_newsletter])
  end

  def preview
    if params[:commit] == PREVIEW
      new_newsletter_from_params
      render('newsletters/preview') && return
    end
  end
end
