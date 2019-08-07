class CardsController < ApplicationController
  before_action :set_card, only: [:edit, :update, :destroy, :check_original_text_card]

  def index
    @cards = Card.all.on_review_date
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    if @card.save
      redirect_to cards_path, notice: 'Карточка создана'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @card.update(card_params)
      redirect_to cards_path, notice: 'Карточка изменена'
    else
      render :edit
    end
  end

  def destroy
    if @card.destroy
      redirect_to cards_path, notice: 'Карточка удалена'
    else
      redirect_to cards_path, notice: 'Произошла ошибка'
    end
  end

  def check_original_text_card
    if @card.check_original_text_answer(params[:answer])
      @card.reset_review_date!
      redirect_to root_path, notice: 'Верно'
    else
      redirect_to root_path, alert: "Не угадал, правильный ответ: #{@card.original_text}"
    end
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text)
  end
end
