class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :approve_form, :approve, :home_page_order_update]
  filter_resource_access additional_collection: [:search]
  before_action :merge_status_to_params, only: [:create, :update]
  before_action :display_preview, only: [:create, :update, :approve]
  skip_before_action :application_meta_tag, only: [:show]

  SAVE = "Save as draft"
  SUBMIT_FOR_APPROVAL = "Submit for approval"
  PUBLISH = "Publish"
  PREVIEW = "Preview"

  def show
  end

  def new
    @article = Article.new
    @article.build_cover_image
  end

  def edit
    @article.build_cover_image if @article.cover_image.blank?
  end

  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.save
        assign_owner
        article_arrival_notification
        format.html { redirect_to articles_path, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        assign_owner
        article_arrival_notification
        format.html { redirect_to articles_path, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    @articles = Article.send("search_by_#{params[:search]}", params[:q])
  end

  def index
    @articles = current_user.articles
    @proxy_articles = current_user.proxy_articles - @articles
    @articles_submitted = Article.where(status: Article::Status::SUBMITTED_FOR_APPROVAL) unless current_user.registered_user?
  end

  def approve_form
    @article.build_cover_image if @article.cover_image.blank?
  end

  def approve
    if @article.update(article_params)
      assign_owner
      if params[:commit] == PUBLISH
        @article.update_attributes(status: Article::Status::PUBLISHED)
        ArticleMailer.published_notification_to_owner(@article.principal_author, @article).deliver_now
        ArticleMailer.published_notification_to_editors(@article).deliver_now
      end
      redirect_to articles_path, notice: 'Article was successfully updated.'
    else
      render :approve_form
    end
  end

  def home_page_order_update
    order_params = {home_page_order: article_params[:home_page_order]}
    Article.where(order_params).update_all(home_page_order: nil)
    @article.update_attributes(order_params)
    redirect_to root_path(configure_home: true)
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def new_article_from_params
    @article = params[:article] ? Article.new(article_params) : Article.new
  end

  def article_params
    params.require(:article).permit(:title, :content, :creator_id, :tag_list, :top_story, :status, :author_content, :summary, :home_page_order, :category_id, :owner_id,
                                    cover_image_attributes: [:cover_photo, :id])
  end

  def merge_status_to_params
    for_publish_or_approval do
      status = current_user.registered_user? ? Article::Status::SUBMITTED_FOR_APPROVAL : Article::Status::PUBLISHED
      params["article"].merge!(status: status, author_content: params["article"]["content"])
    end
  end

  def article_arrival_notification
    for_publish_or_approval do
      ArticleMailer.notification_to_owner(@article.principal_author, @article).deliver_now
      ArticleMailer.notification_to_editors(@article).deliver_now
    end
  end

  def for_publish_or_approval
    if((params[:commit] == SUBMIT_FOR_APPROVAL) || params[:commit] == PUBLISH)
      yield if block_given?
    end
  end

  def display_preview
    if params[:commit] == PREVIEW
      preview_cover_image_attributes = article_params.slice(:cover_image_attributes)[:cover_image_attributes].try(:except, :id)
      @article = Article.new(article_params.except(:cover_image_attributes))
      if preview_cover_image_attributes
        ci = CoverImage.create(preview_cover_image_attributes.merge(preview_image: true))
        @article.cover_image = ci
      end
      render 'articles/preview' and return
    end
  end

  def assign_owner
    owner_type, owner_id = params[:owner_id].split(":")
    @article.article_owners = [ ArticleOwner.new(owner_id: owner_id, owner_type: owner_type) ]
  end
end

