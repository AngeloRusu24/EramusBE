class CreateUtenti < ActiveRecord::Migration[8.1]
  def change
    create_table :utenti, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :nome
      t.string :cognome
      t.date :data_nascita
      t.references :ruolo, type: :uuid, foreign_key: true
      t.integer :tentativi_login_falliti, null: false, default: 0
      t.string :stato_account, null: false, default: 'Attivo'
      t.datetime :ultimo_login
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :utenti, :username, unique: true
    add_index :utenti, :email, unique: true
  end
end