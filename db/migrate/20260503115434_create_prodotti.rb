class CreateProdotti < ActiveRecord::Migration[8.1]
  def change
    create_table :prodotti, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :nome_oggetto, null: false
      t.text :descrizione
      t.integer :quantita_disponibile, null: false, default: 0
      t.decimal :prezzo_unitario, precision: 10, scale: 2, null: false
      t.integer :soglia_minima_magazzino, null: false, default: 0
      t.datetime :data_inserimento, null: false, default: -> { 'NOW()' }
      t.references :tipo_prodotto, type: :uuid, foreign_key: true
      t.references :creato_da, type: :uuid, foreign_key: { to_table: :utenti }
      t.datetime :deleted_at
      t.datetime :updated_at
    end
  end
end