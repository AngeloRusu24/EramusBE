class CreateMovimentiMagazzino < ActiveRecord::Migration[8.1]
  def change
    create_table :movimenti_magazzino, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :prodotto, type: :uuid, null: false, foreign_key: true
      t.string :tipo_movimento, null: false
      t.integer :quantita, null: false
      t.datetime :data_movimento, null: false, default: -> { 'NOW()' }
      t.references :utente_operazione, type: :uuid, foreign_key: { to_table: :utenti }
      t.text :note
    end
  end
end