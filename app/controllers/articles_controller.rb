class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :approve_form, :approve]
  filter_resource_access additional_collection: [:search, :home_page_order]
  before_action :merge_status_to_params, only: [:create, :update]
  skip_before_action :application_meta_tag, only: [:show]

  SAVE = "Save as draft"
  SUBMIT_FOR_APPROVAL = "Submit for approval"
  PUBLISH = "Publish"

  def show
    set_meta_tags ({
                  site: "Baraza",
                  title: @article.title,
                  separator: "|",
                  og: {
                      site: "Baraza",
                      title: @article.title,
                      url: article_url(@article),
                      description: @article.summary,
                      image: @article.cover_image.url
                  },
                  twitter: {
                      card: "summary",
                      site: "Baraza",
                      title: @article.title,
                      url: article_url(@article),
                      description: @article.summary,
                      image: @article.cover_image.url
                  }
    })
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.save
        article_arrival_notification
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
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
        article_arrival_notification
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
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
    @articles_submitted = Article.where(status: Article::Status::SUBMITTED_FOR_APPROVAL) unless current_user.registered_user?
  end

  def approve_form
  end

  def approve
    if @article.update(article_params)
      if params[:commit] == PUBLISH
        @article.update_attributes(status: Article::Status::PUBLISHED)
        ArticleMailer.published_notification_to_creator(@article.user, @article).deliver_later
      end
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :approve_form
    end
  end

  def home_page_order
    @published_articles = Article.where(status: Article::Status::PUBLISHED).order(:home_page_order)
    articles = @published_articles.select{ |article| article.home_page_order.present? }.group_by(&:home_page_order)
    @articles_with_order = (1..8).inject({}) do |result, order|
      result[order] = articles[order].try(:first)
      result
    end
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def new_article_from_params
    @article = params[:article] ? Article.new(article_params) : Article.new
  end

  def article_params
    params.require(:article).permit(:title, :content, :user_id, :tag_list, :top_story, :cover_image, :status, :author_content, :summary, :home_page_order, category_ids: [])
  end

  def merge_status_to_params
    for_publish_or_approval do
      status = current_user.registered_user? ? Article::Status::SUBMITTED_FOR_APPROVAL : Article::Status::PUBLISHED
      params["article"].merge!(status: status, author_content: params["article"]["content"])
    end
  end

  def article_arrival_notification
    for_publish_or_approval do
      ArticleMailer.notification_to_creator(current_user, @article).deliver_later
      ArticleMailer.notification_to_editors(@article).deliver_later
    end
  end

  def for_publish_or_approval
    if((params[:commit] == SUBMIT_FOR_APPROVAL) || params[:commit] == PUBLISH)
      yield if block_given?
    end
  end
end

