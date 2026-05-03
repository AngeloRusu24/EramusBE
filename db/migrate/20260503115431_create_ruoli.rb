class CreateRuoli < ActiveRecord::Migration[8.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :ruoli, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :nome, null: false
      t.text :descrizione
      t.timestamps
    end
    add_index :ruoli, :nome, unique: true
  end
end