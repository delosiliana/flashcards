class DecksController < ApplicationController
  before_action :set_deck, only: [:edit, :update, :destroy, :show, :set_current]

  def index
    @decks = current_user.decks.order(created_at: :desc)
  end

  def show; end

  def new
    @deck = current_user.decks.new
  end

  def create
    @deck = current_user.decks.new(deck_params)
    if @deck.save
      redirect_to decks_path, notice: 'Колода создана'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @deck.update(deck_params)
      redirect_to decks_path, notice: 'Доска обновлена'
    else
      render :edit
    end
  end

  def destroy
    if @deck.destroy
      redirect_to decks_path, notice: 'Карточка удалена'
    else
      redirect_to root_path, notice: 'Произошла ошибка'
    end
  end

  def set_current
    @deck.set_current
    redirect_to @deck
  end

  private

  def set_deck
    @deck = current_user.decks.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:title, :user_id, :set_current)
  end
end
