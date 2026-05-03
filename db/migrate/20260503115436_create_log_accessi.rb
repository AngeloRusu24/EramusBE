class CreateLogAccessi < ActiveRecord::Migration[8.1]
  def change
    create_table :log_accessi, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :utente, type: :uuid, foreign_key: true
      t.datetime :data_accesso, null: false, default: -> { 'NOW()' }
      t.string :esito, null: false
      t.string :indirizzo_ip
    end
  end
end