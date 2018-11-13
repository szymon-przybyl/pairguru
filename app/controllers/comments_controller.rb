class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.new comment_params
    if @comment.save
      redirect_to @comment.movie, notice: 'Comment created!'
    else
      redirect_to @comment.movie || :movies, alert: @comment.errors.full_messages.join(', ')
    end
  end

  def destroy
    @comment = current_user.comments.find params[:id]
    @comment.destroy
    redirect_to @comment.movie
  end

  private

  def comment_params
    params.require(:comment).permit(:movie_id, :content)
  end
end
