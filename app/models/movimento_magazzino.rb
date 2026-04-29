class MovimentoMagazzino < ApplicationRecord
  self.table_name = 'movimenti_magazzino'
 
  belongs_to :prodotto
  belongs_to :utente_operazione, class_name: 'Utente', foreign_key: :utente_operazione_id, optional: true
 
  validates :tipo_movimento, inclusion: { in: %w[Carico Scarico] }
  validates :quantita, numericality: { greater_than: 0 }
 
  after_create :aggiorna_quantita_prodotto
 
  private
 
  def aggiorna_quantita_prodotto
    delta = tipo_movimento == 'Carico' ? quantita : -quantita
    prodotto.increment!(:quantita_disponibile, delta)
  end
end
