class NewsPostsController < ApplicationController
  before_action :set_news_post, only: [:show, :edit, :update, :destroy, :icon]
  include PublicActivity::StoreController

  # GET /news_posts
  # GET /news_posts.json
  def index
    @category = params[:category]
    @news_posts = NewsPost.order(updated_at: :desc)
    if !params[:tag].blank?
      @news_posts = @news_posts.with_tag(params[:tag]).page(params[:page])
    elsif !params[:category].blank?
      @news_posts = @news_posts.with_category(params[:category]).page(params[:page])
    elsif !params[:group_id].blank?
      @news_posts = @news_posts.includes(:groups).where(groups: { id: params[:group_id] }).page(params[:page])
    else
      @news_posts = @news_posts.all.page(params[:page])
    end
  end

  # GET /news_posts/1
  # GET /news_posts/1.json
  def show
  end

  # GET /news_posts/new
  def new
    @news_post = NewsPost.new
  end

  # GET /news_posts/1/edit
  def edit
  end

  # POST /news_posts
  # POST /news_posts.json
  def create
    @news_post = NewsPost.new(news_post_params)
    @news_post.category = news_post_params[:for_roles]

    respond_to do |format|
      if @news_post.save
        format.html { redirect_to @news_post, notice: t('news.post_created') }
        format.json { render action: 'show', status: :created, location: @news_post }
      else
        format.html { render action: 'new' }
        format.json { render json: @news_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news_posts/1
  # PATCH/PUT /news_posts/1.json
  def update
    respond_to do |format|
      @news_post.category = news_post_params[:for_roles]
      if @news_post.update(news_post_params.except(:for_roles))
        format.html { redirect_to @news_post, notice: t('news.post_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @news_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def icon
    if @news_post.icon.destroy
      @news_post.save
      redirect_to edit_news_post_path(@news_post)
    else
      redirect_to edit_news_post_path(@news_post), :alert => t('activerecord.errors.models.avatar.delete')
    end
  end

  # DELETE /news_posts/1
  # DELETE /news_posts/1.json
  def destroy
    @news_post.destroy
    respond_to do |format|
      format.html { redirect_to news_posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_post
      @news_post = NewsPost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_post_params
      params.require(:news_post).permit(:title, :content, :tags, :icon, :for_roles, :created_at, :updated_at, :documets).
          merge({ groups: Group.where(id: params[:for_groups]), documents: Document.where(id: params[:news_post][:documents]), creator_id: current_user.id })
    end
end
