module Api
  module V1
    class ProdottiController < ApplicationController
      before_action :set_prodotto, only: [:show, :update, :destroy]

      def index
        prodotti = Prodotto.attivi.includes(:tipo_prodotto)
        prodotti = prodotti.where("nome_oggetto ILIKE ?", "%#{params[:q]}%") if params[:q]
        prodotti = prodotti.where(tipo_prodotto_id: params[:tipo_id]) if params[:tipo_id]
        prodotti = case params[:order]
                   when 'prezzo_asc' then prodotti.order(prezzo_unitario: :asc)
                   when 'prezzo_desc' then prodotti.order(prezzo_unitario: :desc)
                   when 'quantita_asc' then prodotti.order(quantita_disponibile: :asc)
                   when 'quantita_desc' then prodotti.order(quantita_disponibile: :desc)
                   else prodotti.order(data_inserimento: :desc)
                   end
        prodotti = prodotti.page(params[:page]).per(params[:per_page] || 10)

        render json: {
          prodotti: prodotti.map { |p| prodotto_json(p) },
          meta: { total: prodotti.total_count, page: prodotti.current_page }
        }
      end

      def show
        render json: prodotto_json(@prodotto)
      end

      def create
        prodotto = Prodotto.new(prodotto_params.merge(creato_da: @current_user.id))
        if prodotto.save
          render json: prodotto_json(prodotto), status: :created
        else
          render json: { errors: prodotto.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @prodotto.update(prodotto_params)
          render json: prodotto_json(@prodotto)
        else
          render json: { errors: @prodotto.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @prodotto.soft_delete!
        render json: { message: 'Prodotto eliminato' }
      end

      private

      def set_prodotto
        @prodotto = Prodotto.attivi.find(params[:id])
      end

      def prodotto_params
        params.require(:prodotto).permit(:nome_oggetto, :descrizione, :quantita_disponibile,
                                         :prezzo_unitario, :soglia_minima_magazzino, :tipo_prodotto_id)
      end

      def prodotto_json(prodotto)
        {
          id: prodotto.id,
          nome_oggetto: prodotto.nome_oggetto,
          descrizione: prodotto.descrizione,
          quantita_disponibile: prodotto.quantita_disponibile,
          prezzo_unitario: prodotto.prezzo_unitario,
          soglia_minima_magazzino: prodotto.soglia_minima_magazzino,
          tipo_prodotto: prodotto.tipo_prodotto&.nome,
          data_inserimento: prodotto.data_inserimento
        }
      end
    end
  end
end