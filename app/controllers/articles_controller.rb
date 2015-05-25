class ArticlesController < InheritedResources::Base
  filter_access_to :all

  private
  def article_params
    params.require(:article).permit(:title, :content, :user_id)
  end
end

