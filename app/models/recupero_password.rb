class RecuperoPassword < ApplicationRecord
  self.table_name = 'recupero_password'
  belongs_to :utente
  validates :token, presence: true, uniqueness: true
 
  def scaduto?
    data_scadenza < Time.current
  end
 
  def usa!
    update!(stato: 'Usato')
  end
end
