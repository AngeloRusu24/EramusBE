module Api
  module V1

class AuthController < ApplicationController
  skip_before_action :authenticate_request!, only: [:login, :refresh, :forgot_password, :reset_password]
 
  # POST /auth/login
  def login
    utente = Utente.find_by(username: params[:username])
 
    if utente.nil? || utente.stato_account == 'Bloccato'
      log_accesso(utente, 'Fallito')
      return render json: { error: 'Credenziali non valide o account bloccato' }, status: :unauthorized
    end
 
    if utente.authenticate(params[:password])
      utente.update!(tentativi_login_falliti: 0, ultimo_login: Time.current)
      log_accesso(utente, 'Successo')
 
      access_token = JwtService.encode_access({ user_id: utente.id })
      refresh_token = JwtService.encode_refresh({ user_id: utente.id })
 
      render json: {
        access_token: access_token,
        refresh_token: refresh_token,
        utente: utente_json(utente)
      }
    else
      tentativi = utente.tentativi_login_falliti + 1
      utente.update!(tentativi_login_falliti: tentativi)
      utente.blocca! if tentativi >= 5
      log_accesso(utente, 'Fallito')
      render json: { error: 'Credenziali non valide' }, status: :unauthorized
    end
  end

    # POST /auth/refresh
  def refresh
    payload = JwtService.decode(params[:refresh_token])
    raise StandardError, 'Non è un refresh token' unless payload[:type] == 'refresh'
 
    utente = Utente.find(payload[:user_id])
    access_token = JwtService.encode_access({ user_id: utente.id })
    render json: { access_token: access_token }
  rescue StandardError => e
    render json: { error: e.message }, status: :unauthorized
  end
 
  # POST /auth/forgot_password
  def forgot_password
    utente = Utente.find_by(email: params[:email])
    if utente
      token = SecureRandom.hex(32)
      utente.recupero_passwords.create!(
        token: token,
        data_generazione: Time.current,
        data_scadenza: 1.hour.from_now
      )
      UtenteMailer.recupero_password(utente, token).deliver_later
    end
    render json: { message: 'Se l\'email esiste, riceverai un link per il reset' }
  end
 
  # POST /auth/reset_password
  def reset_password
    record = RecuperoPassword.find_by(token: params[:token], stato: 'Non usato')
    return render json: { error: 'Token non valido' }, status: :unprocessable_entity if record.nil?
    return render json: { error: 'Token scaduto' }, status: :unprocessable_entity if record.scaduto?
 
    record.utente.update!(password: params[:password])
    record.usa!
    render json: { message: 'Password aggiornata con successo' }
  end
 
  private
 
  def log_accesso(utente, esito)
    LogAccesso.create!(
      utente_id: utente&.id,
      esito: esito,
      indirizzo_ip: request.remote_ip
    )
  end
 
  def utente_json(utente)
    {
      id: utente.id,
      username: utente.username,
      email: utente.email,
      nome: utente.nome,
      cognome: utente.cognome,
      ruolo: utente.ruolo&.nome
    }
  end
end
    end
        end
 
