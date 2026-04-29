module Api
  module V1
    class UtentiController < ApplicationController
      before_action :require_admin!, except: [:me]
      before_action :set_utente, only: [:show, :update, :destroy, :assign_role]

      def index
        utenti = Utente.attivi.includes(:ruolo)
        utenti = utenti.where("username ILIKE ? OR email ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q]
        utenti = utenti.page(params[:page]).per(params[:per_page] || 10)

        render json: {
          utenti: utenti.map { |u| utente_json(u) },
          meta: { total: utenti.total_count, page: utenti.current_page }
        }
      end

      def me
        render json: utente_json(@current_user)
      end

      def show
        render json: utente_json(@utente)
      end

      def create
        utente = Utente.new(utente_params)
        if utente.save
          UtenteMailer.benvenuto(utente).deliver_later
          render json: utente_json(utente), status: :created
        else
          render json: { errors: utente.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @utente.update(utente_params)
          render json: utente_json(@utente)
        else
          render json: { errors: @utente.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @utente.soft_delete!
        render json: { message: 'Utente disattivato' }
      end

      def assign_role
        ruolo = Ruolo.find(params[:ruolo_id])
        @utente.update!(ruolo: ruolo)
        render json: utente_json(@utente)
      end

      private

      def set_utente
        @utente = Utente.attivi.find(params[:id])
      end

      def utente_params
        params.require(:utente).permit(:username, :email, :password, :nome, :cognome, :data_nascita, :ruolo_id)
      end

      def utente_json(utente)
        {
          id: utente.id,
          username: utente.username,
          email: utente.email,
          nome: utente.nome,
          cognome: utente.cognome,
          data_nascita: utente.data_nascita,
          ruolo: utente.ruolo&.nome,
          stato_account: utente.stato_account,
          ultimo_login: utente.ultimo_login,
          created_at: utente.created_at
        }
      end
    end
  end
end