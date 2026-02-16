class SavedSearchesController < WebController
  before_action :require_login

  def index
    @saved_searches = current_user.saved_searches.order(created_at: :desc)
  end

  def create
    unless current_user.can_create_saved_search?
      redirect_to saved_searches_path, alert: "Free plan allows up to 3 saved searches. Upgrade to Pro for unlimited!"
      return
    end

    @saved_search = current_user.saved_searches.build(saved_search_params)

    if @saved_search.save
      redirect_to saved_searches_path, notice: "Search saved! We'll check for new listings periodically."
    else
      redirect_to search_path(q: params[:saved_search][:query]), alert: "Could not save search."
    end
  end

  def destroy
    search = current_user.saved_searches.find(params[:id])
    search.destroy
    redirect_to saved_searches_path, notice: "Search removed."
  end

  def toggle
    search = current_user.saved_searches.find(params[:id])
    search.update!(active: !search.active)
    redirect_to saved_searches_path, notice: "Search #{search.active? ? 'activated' : 'paused'}."
  end

  private

  def saved_search_params
    params.require(:saved_search).permit(:query, :brand, :size, :color, :min_price, :max_price, :category)
  end
end
