class SeachesController < ApplicationController
def search
  @range = params[:range]
  @word = params[:word]
  if @range == 'User'
    @users = User.looks(params[:search], params[:word])
  else
    @post_images = PostImage.looks(params[:search], params[:word])

end
