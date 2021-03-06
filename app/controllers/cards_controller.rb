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
    check_result = @card.typo_text(params[:answer])
    if check_result < 1
      @card.rise_try_count
      flash[:success] = "Верно"
    elsif check_result == 1
      @card.rise_try_count
      flash[:danger] = "Вы ввели ответ #{params[:answer]} но правильный ответ: #{@card.original_text}"
    else
      @card.process_mistake
      flash[:error] = "Не угадал, правильный ответ: #{@card.original_text}"
    end
    @card.save
    redirect_to root_path
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :picture, :deck_id, :review_date)
  end
end
