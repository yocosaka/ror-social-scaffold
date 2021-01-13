class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.new
    timeline_posts
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      timeline_posts
      render :index, alert: 'Post was not created.'
    end
  end

  private

  def timeline_posts
    target_posts = []
    current_user.friends.each do |friend|
      target_posts << friend.posts
    end
    target_posts << current_user.posts
    @timeline_posts ||= target_posts.flatten.sort_by(&:updated_at).reverse

    # SELECT content, user_id, created_at, updated_at
    # FROM users JOIN posts on users.id == posts.user_id
    # WHERE user.id == user_id
    # new_table = User.joins('INNER JOIN posts ON users.id == posts.user_id')
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
