module Api
  module V1
    class TipoProdottoController < ApplicationController
      def index
        tipi = TipoProdotto.all
        render json: tipi.map { |t| { id: t.id, nome: t.nome } }
      end
    end
  end
end