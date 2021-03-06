class RewardsController < ApplicationController
  before_action :set_reward, only: [:show, :edit, :update, :destroy]

  def index
    @family = User.where(family: current_user.family)
    @family_rewards = Reward.where(user: @family)
    @rewards = Reward.where(family: current_user.family)
    @rewards = policy_scope(current_user.rewards)
  end

  def show
  end

  def new
    @family = Family.find(params[:family_id])
    @reward = Reward.new
    @children = User.where(family: current_user.family).where(child: true)
    @partnairs = Partnair.all.collect(&:name)
    authorize @reward
  end

  def create
    @reward = Reward.new(rewards_params)
    @family = Family.find(params[:family_id])
    authorize @reward
    if @reward.save
      redirect_to family_rewards_path(current_user.family.id)
      flash[:alert] = "Votre récompense a bien été créée"
    else
      puts "fail"
      render new
    end
  end

  def edit
    @children = User.where(family: current_user.family).where(child: true)
  end

  def update
    @reward.update(rewards_params)
    @user = @reward.user
    if @reward.done?
      @user.point -= @reward.price
      @user.save
      redirect_to family_rewards_path(current_user.family.id)
      flash[:notice] = "C'est parti pour profiter un MAXXXX"
    else
      redirect_to family_rewards_path(current_user.family.id)
      flash[:notice] = "Il semble que quelquechose se soit mal passé... Réessaye"
    end
  end

  def destroy
    @reward.destroy
    redirect_to family_rewards_path(current_user.family.id)

  end

  private

  def set_reward
    @reward = Reward.find(params[:id])
    authorize @reward
  end

  def rewards_params
    params.require(:reward).permit(:user_id, :name, :price, :done)
  end
end
