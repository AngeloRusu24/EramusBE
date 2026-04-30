module Api
  module V1
    class RuoliController < ApplicationController
      def index
        ruoli = Ruolo.all
        render json: ruoli.map { |r| { id: r.id, nome: r.nome } }
      end
    end
  end
end