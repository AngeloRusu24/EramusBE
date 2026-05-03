class CreateTipoProdotto < ActiveRecord::Migration[8.1]
  def change
    create_table :tipo_prodotto, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :nome, null: false
      t.text :descrizione
      t.timestamps
    end
    add_index :tipo_prodotto, :nome, unique: true
  end
end