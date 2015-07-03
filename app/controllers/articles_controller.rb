class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  filter_resource_access additional_collection: [:search]
  before_action :merge_status_to_params, only: [:create, :update]

  SAVE = "Save as draft"
  SUBMIT_FOR_APPROVAL = "Submit for approval"
  PUBLISH = "Publish"

  def show
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
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def new_article_from_params
    @article = params[:article] ? Article.new(article_params) : Article.new
  end

  def article_params
    params.require(:article).permit(:title, :content, :user_id, :tag_list, :top_story, :cover_image, :status, :author_content, category_ids: [])
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

