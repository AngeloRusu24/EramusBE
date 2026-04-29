class UtenteMailer < ApplicationMailer
  def benvenuto(utente)
    @utente = utente
    mail(to: utente.email, subject: 'Benvenuto nel sistema ERAMUS')
  end

  def recupero_password(utente, token)
    @utente = utente
    @reset_url = "#{ENV['FRONTEND_URL']}/reset-password?token=#{token}"
    mail(to: utente.email, subject: 'Recupero Password - ERAMUS')
  end
end