class TipoProdotto < ApplicationRecord
  self.table_name = 'tipo_prodotto'
  has_many :prodotti, class_name: 'Prodotto'
  validates :nome, presence: true, inclusion: { in: %w[Buste Carta Toner] }, uniqueness: true
end
