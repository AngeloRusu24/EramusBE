class LogAccesso < ApplicationRecord
  self.table_name = 'log_accessi'
  belongs_to :utente, optional: true
  validates :esito, inclusion: { in: %w[Successo Fallito] }
end
