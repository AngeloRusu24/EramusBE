module Api
  module V1



class DashboardController < ApplicationController
  def index
    render json: {
      totale_utenti: Utente.attivi.count,
      totale_prodotti: Prodotto.attivi.count,
      valore_totale_inventario: Prodotto.attivi.sum('quantita_disponibile * prezzo_unitario').to_f.round(2),
      ultimi_movimenti: ultimi_movimenti,
      prodotti_per_categoria: prodotti_per_categoria
    }
  end
 
  private
 
  def ultimi_movimenti
    MovimentoMagazzino.includes(:prodotto)
                      .order(data_movimento: :desc)
                      .limit(5)
                      .map { |m|
                        {
                          prodotto: m.prodotto&.nome_oggetto,
                          tipo: m.tipo_movimento,
                          quantita: m.quantita,
                          data: m.data_movimento
                        }
                      }
  end
 
  def prodotti_per_categoria
    TipoProdotto.joins(:prodotti)
                .where(prodotti: { deleted_at: nil })
                .group('tipo_prodotto.nome')
                .count
  end
end
    end
        end
 
 

