class ApplicationController < ActionController::API
  before_action :authenticate_request!

  private

  def authenticate_request!
    header = request.headers['Authorization']
    token = header&.split(' ')&.last
    raise StandardError, 'Token mancante' unless token

    @payload = JwtService.decode(token)
    raise StandardError, 'Token non è access token' unless @payload[:type] == 'access'

    @current_user = Utente.find(@payload[:user_id])
    raise StandardError, 'Account bloccato' if @current_user.stato_account == 'Bloccato'
  rescue StandardError => e
    render json: { error: e.message }, status: :unauthorized
  end

  def require_admin!
    render json: { error: 'Accesso negato: solo Admin' }, status: :forbidden unless @current_user.admin?
  end
end