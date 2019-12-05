class CardsController < ApplicationController
  before_action :set_card, only: [:edit, :update, :destroy, :check_original_text_card]

  def index
    @cards = current_user.cards.on_review_date
  end

  def new
    @card = current_user.cards.build
  end

  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      redirect_to cards_path, notice: 'Карточка создана'
    else
      render :new
    end
  end

  def edit; end

  def update
    if current_user.author?(@card)
      @card.update(card_params)
      redirect_to cards_path, notice: 'Карточка обновлена'
    else
      render :edit
    end
  end

  def destroy
    if current_user.author?(@card)
      @card.destroy
      redirect_to cards_path, notice: 'Карточка удалена'
    else
      redirect_to cards_path, notice: 'Произошла ошибка'
    end
  end

  def check_original_text_card
    if @card.check_original_text_answer(params[:answer])
      @card.check_try_count
      redirect_to root_path, notice: 'Верно'
    else
      @card.check_mistake_count
      redirect_to root_path, alert: "Не угадал, правильный ответ: #{@card.original_text}"
    end
    @card.save
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :picture, :deck_id, :review_date)
  end
end
