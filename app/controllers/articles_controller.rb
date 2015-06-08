class ArticlesController < InheritedResources::Base
  filter_resource_access

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  def new_article_from_params
    @article = params[:article] ? Article.new(article_params) : Article.new
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:title, :content, :user_id, :tag_list, :top_story, category_ids: [])
  end
end

