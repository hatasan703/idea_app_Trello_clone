class CommentsController < ApplicationController

  before_action :set_comment, only: [:destroy]

  
  def create
    @comment = Comment.new(comment_params)
    company_id = Idea.find(params[:idea_id]).company_id
    respond_to do |format|
      if @comment.save
        format.html { redirect_to public_company_ideas_path(company_id) }
        format.json { render :show, status: :created, location: @comment }
      else
        redirect_to public_company_ideas_path(company_id)
      end
    end
  end

  def destroy
    if current_user.id == @comment.user_id
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to comments_url, notice: 'comment was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end


  private
  def comment_params
    params.require(:comment).permit(:idea_id, :content).merge(user_id: current_user.id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
