class ArticlesController < ApplicationController
  before_action :set_article, only: [:update, :show, :edit, :destroy, :approve_form, :approve, :home_page_order_update]

  filter_resource_access additional_collection: [:search]
  before_action :merge_status_to_params, only: [:create, :update]
  #before_action :display_preview, only: [ :approve]
  before_action :new_article_from_params, only: [:new, :create]
  skip_before_action :application_meta_tag, only: [:show]

  SAVE = 'Save as draft'
  SUBMIT_FOR_APPROVAL = 'Submit for approval'
  PUBLISH = 'Publish'
  PREVIEW = 'Preview'

  module Search
    extend ListValues
    ALL = 'all'
    TAGS = 'tags'
    CATEGORY = 'category'
  end

  def show
  end

  def new
    build_cover_image
  end

  def edit
    build_cover_image
  end

  def create
    if @article.save
        # TODO: Vijay: Maybe the owner assignment should be done before the save is tried, thus the notification can be done as an after save hoook on the model, as opposed to the controller
        # This actually creates a different model. It is not dirtying the article.
      assign_owner
      article_arrival_notification
      if params[:commit] == PREVIEW
        render(:preview)
      else
        if params[:commit] == PUBLISH
          redirect_to articles_path, notice: 'Article was successfully published.'
        else
          if params[:commit] == SAVE
            redirect_to articles_path, notice: 'Article was successfully saved.'
          else
            redirect_to articles_path, notice: 'Article was successfully updated.'
          end
        end
      end
    else
      render(:new)
    end
  end

  def update
    if @article.update(article_params)
      assign_owner
      article_arrival_notification
      if params[:commit] == PREVIEW
        build_cover_image
        render(:preview)
      else
        if params[:commit] == PUBLISH
          redirect_to articles_path, notice: 'Article was successfully published.'
        else
          if params[:commit] == SAVE
            redirect_to articles_path, notice: 'Article was successfully saved.'
          else
            redirect_to articles_path, notice: 'Article was successfully updated.'
          end
        end
      end
    else
      render(:edit)
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def search
    if params[:search] == ArticlesController::Search::CATEGORY
      @articles = Article.includes(:category).where(['categories.name = ? and status != ?',  params[:q], Article::Status::PREVIEW ]).references(:category)
    else
      if params[:search] == ArticlesController::Search::TAGS
        @articles = Article.includes(:tags).where(['tags.name= ? and status != ?', params[:q], Article::Status::PREVIEW ]).references(:tags)
      else
        if params[:search] == ArticlesController::Search::ALL
          query_string = "%" + params[:q].upcase + "%"
          @articles = Article.includes(:tags, :users, :category ).where(
            [
              "(upper(title) like ? or upper(summary) like ? or upper(content) like ? or upper(tags.name) like ? or upper(categories.name) like ? or upper(users.first_name) like ? or upper(users.last_name) like ? ) and status != ?",
              query_string,
              query_string,
              query_string,
              query_string,
              query_string,
              query_string,
              query_string,
              Article::Status::PREVIEW
            ]
          ).references(:tags, :users )
        end
      end
    end
  end

  def index
    @articles = current_user.articles.includes(:users, :system_users).where('status != ?',  Article::Status::PREVIEW)
    @proxy_articles = current_user.proxy_articles.includes(:users, :system_users).where('status != ?', Article::Status::PREVIEW) - @articles
    @articles_submitted = Article.where(status: Article::Status::SUBMITTED_FOR_APPROVAL).includes(:users, :system_users) unless current_user.registered_user?
    @articles_by_others = Article.where(status: Article::Status::PUBLISHED).includes(:users, :system_users) unless current_user.registered_user?

  end

  def approve_form
    build_cover_image
  end

  def approve
    if @article.update(article_params)
      assign_owner
      if params[:commit] == PUBLISH
        @article.update_attributes(status: Article::Status::PUBLISHED)
        ArticleMailer.published_notification_to_owner(@article.principal_author, @article).deliver_now
        ArticleMailer.published_notification_to_editors(@article).deliver_now
        redirect_to articles_path, notice: 'Article was successfully updated.'
      else
        if params[:commit] == PREVIEW
          render(:preview)
        else
          if params[:commit] == SAVE
            redirect_to articles_path, notice: 'Article was successfully saved.'
          end
        end
      end
    else
      render :approve_form
    end
  end

  def home_page_order_update
    order_params = article_params.slice(:home_page_order)
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

  def build_cover_image
    @article.build_cover_image if @article.cover_image.blank?
  end

  def merge_status_to_params
    for_publish_or_approval do
      status = current_user.registered_user? ? Article::Status::SUBMITTED_FOR_APPROVAL : Article::Status::PUBLISHED
      params[:article].merge!(status: status, author_content: params[:article][:content])
    end
    if params[:commit] == PREVIEW && @article.status == nil
      status = Article::Status::PREVIEW
      params[:article].merge!(status: status, author_content: params[:article][:content])
    end
  end

  def article_arrival_notification
    for_publish_or_approval do
      ArticleMailer.notification_to_owner(@article.principal_author, @article).deliver_now
      ArticleMailer.notification_to_editors(@article).deliver_now
    end
  end

  def for_publish_or_approval
    yield if params[:commit] == SUBMIT_FOR_APPROVAL || params[:commit] == PUBLISH
  end

  def display_preview
    if params[:commit] == PREVIEW
      #preview_cover_image_attributes = article_params.slice(:cover_image_attributes)[:cover_image_attributes].try(:except, :id)
      #preview_article = Article.new(article_params.except(:cover_image_attributes))
      #if preview_cover_image_attributes.present?
      #  # TODO: Vijay: Why is this child being 'create'd when the parent is only 'new'ed? - since we wanted to resize and view the image. this happens only on save. We planned to have a rake task that clears out the orphan records
      #  ci = CoverImage.create(preview_cover_image_attributes.merge(preview_image: true))
      #  preview_article.cover_image = ci
      #else
      #  preview_article.cover_image = @article.cover_image
      #end
      #@article = preview_article
      build_cover_image
      render(:preview) && return
    end
  end

  def assign_owner
    if params[:owner_id]
      owner_type, owner_id = params[:owner_id].split(':')
      @article.article_owners = [ArticleOwner.new(owner_id: owner_id, owner_type: owner_type)]
    end
  end
end
