class Prodotto < ApplicationRecord
  self.table_name = 'prodotti'
 
  belongs_to :tipo_prodotto
  belongs_to :creato_da_utente, class_name: 'Utente', foreign_key: :creato_da
  has_many :movimenti_magazzino, foreign_key: :prodotto_id
 
  validates :nome_oggetto, presence: true
  validates :prezzo_unitario, numericality: { greater_than_or_equal_to: 0 }
  validates :quantita_disponibile, numericality: { greater_than_or_equal_to: 0 }
 
  scope :attivi, -> { where(deleted_at: nil) }
 
  def soft_delete!
    update!(deleted_at: Time.current)
  end
end
