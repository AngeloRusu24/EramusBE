class NotificaEmail < ApplicationRecord
  self.table_name = 'notifiche_email'
  belongs_to :utente, optional: true
  validates :esito_invio, inclusion: { in: %w[Inviato Fallito] }
end
