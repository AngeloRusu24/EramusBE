module Api
  module V1
    class MovimentiController < ApplicationController
      def index
        movimenti = MovimentoMagazzino.includes(:prodotto, :utente_operazione)
                                      .order(data_movimento: :desc)
                                      .limit(5)
        render json: movimenti.map { |m|
          {
            id: m.id,
            prodotto: m.prodotto&.nome_oggetto,
            tipo_movimento: m.tipo_movimento,
            quantita: m.quantita,
            data_movimento: m.data_movimento,
            operatore: "#{m.utente_operazione&.nome} #{m.utente_operazione&.cognome}",
            note: m.note
          }
        }
      end

      def create
        movimento = MovimentoMagazzino.new(movimento_params.merge(utente_operazione_id: @current_user.id))
        if movimento.save
          render json: { message: 'Movimento registrato', id: movimento.id }, status: :created
        else
          render json: { errors: movimento.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def movimento_params
        params.require(:movimento).permit(:prodotto_id, :tipo_movimento, :quantita, :note)
      end
    end
  end
end