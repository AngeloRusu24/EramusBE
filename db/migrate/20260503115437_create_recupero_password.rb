class CreateRecuperoPassword < ActiveRecord::Migration[8.1]
  def change
    create_table :recupero_password, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :utente, type: :uuid, null: false, foreign_key: true
      t.string :token, null: false
      t.datetime :data_generazione, null: false, default: -> { 'NOW()' }
      t.datetime :data_scadenza, null: false
      t.string :stato, null: false, default: 'Non usato'
    end
    add_index :recupero_password, :token, unique: true
  end
end