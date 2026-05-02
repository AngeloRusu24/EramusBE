module Api
  module V1
    class RuoliController < ApplicationController
      before_action :require_admin!

      def index
        ruoli = Ruolo.all
        render json: ruoli.map { |r| { id: r.id, nome: r.nome, descrizione: r.descrizione } }
      end

      def update
        ruolo = Ruolo.find(params[:id])
        if ruolo.update(ruolo_params)
          render json: { id: ruolo.id, nome: ruolo.nome, descrizione: ruolo.descrizione }
        else
          render json: { errors: ruolo.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def ruolo_params
        params.require(:ruolo).permit(:descrizione)
      end
    end
  end
end