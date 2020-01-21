class NotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.pending_cards.subject
  #
  def pending_cards(user)
    @email = user.email
    mail to: @email, subject: 'Карточки, которые ожидают пересмотра'
  end
end
