class Ruolo < ApplicationRecord
  self.table_name = 'ruoli'
  has_many :utenti
  validates :nome, presence: true, inclusion: { in: %w[Admin Operatore] }, uniqueness: true
end
