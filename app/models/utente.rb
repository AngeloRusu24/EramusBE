class Utente < ApplicationRecord
  self.table_name = 'utenti'
 
  has_secure_password
 
  belongs_to :ruolo, optional: true
  has_many :prodotti, foreign_key: :creato_da
  has_many :movimenti_magazzino, foreign_key: :utente_operazione_id
  has_many :log_accessi, foreign_key: :utente_id
  has_many :recupero_passwords, foreign_key: :utente_id
  has_many :notifiche_emails, foreign_key: :utente_id
 
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, format: {
    with: /\A(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}\z/,
    message: "deve avere almeno 8 caratteri, 1 maiuscola, 1 numero, 1 carattere speciale"
  }, allow_nil: true
 
  scope :attivi, -> { where(deleted_at: nil) }
 
  def soft_delete!
    update!(deleted_at: Time.current, stato_account: 'Bloccato')
  end
 
  def blocca!
    update!(stato_account: 'Bloccato')
  end
 
  def admin?
    ruolo&.nome == 'Admin'
  end
end
