class CreateNotificheEmail < ActiveRecord::Migration[8.1]
  def change
    create_table :notifiche_email, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :utente, type: :uuid, foreign_key: true
      t.text :corpo_messaggio
      t.datetime :data_invio, null: false, default: -> { 'NOW()' }
      t.string :esito_invio, null: false, default: 'Inviato'
    end
  end
end