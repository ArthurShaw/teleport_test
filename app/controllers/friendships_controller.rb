class FriendshipsController < ApplicationController
  def index
    @friends = current_user.friends
    @users = User.unfriended(current_user)
  end
  
  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      redirect_to friendships_path, notice: 'Друг добавлен'
    else
      redirect_to friendships_path, notice: 'Невозможно добавить друга'
    end
  end
  
  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    redirect_to friendships_path, notice: 'Друг удален'
  end
end
