# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "log_accessi", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "data_accesso", precision: nil, default: -> { "now()" }, null: false
    t.string "esito", limit: 20, null: false
    t.string "indirizzo_ip", limit: 45
    t.uuid "utente_id"
    t.check_constraint "esito::text = ANY (ARRAY['Successo'::character varying, 'Fallito'::character varying]::text[])", name: "log_accessi_esito_check"
  end

  create_table "movimenti_magazzino", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "data_movimento", precision: nil, default: -> { "now()" }, null: false
    t.text "note"
    t.uuid "prodotto_id", null: false
    t.integer "quantita", null: false
    t.string "tipo_movimento", limit: 20, null: false
    t.uuid "utente_operazione_id"
    t.check_constraint "tipo_movimento::text = ANY (ARRAY['Carico'::character varying, 'Scarico'::character varying]::text[])", name: "movimenti_magazzino_tipo_movimento_check"
  end

  create_table "notifiche_email", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "corpo_messaggio"
    t.datetime "data_invio", precision: nil, default: -> { "now()" }, null: false
    t.string "esito_invio", limit: 20, default: "Inviato", null: false
    t.uuid "utente_id"
    t.check_constraint "esito_invio::text = ANY (ARRAY['Inviato'::character varying, 'Fallito'::character varying]::text[])", name: "notifiche_email_esito_invio_check"
  end

  create_table "prodotti", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "creato_da"
    t.datetime "data_inserimento", precision: nil, default: -> { "now()" }, null: false
    t.datetime "deleted_at", precision: nil
    t.text "descrizione"
    t.string "nome_oggetto", limit: 255, null: false
    t.decimal "prezzo_unitario", precision: 10, scale: 2, null: false
    t.integer "quantita_disponibile", default: 0, null: false
    t.integer "soglia_minima_magazzino", default: 0, null: false
    t.uuid "tipo_prodotto_id"
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
  end

  create_table "recupero_password", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "data_generazione", precision: nil, default: -> { "now()" }, null: false
    t.datetime "data_scadenza", precision: nil, null: false
    t.string "stato", limit: 20, default: "Non usato", null: false
    t.string "token", limit: 255, null: false
    t.uuid "utente_id", null: false

    t.check_constraint "stato::text = ANY (ARRAY['Usato'::character varying, 'Non usato'::character varying]::text[])", name: "recupero_password_stato_check"
    t.unique_constraint ["token"], name: "recupero_password_token_key"
  end

  create_table "ruoli", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.text "descrizione"
    t.string "nome", limit: 50, null: false
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false

    t.check_constraint "nome::text = ANY (ARRAY['Admin'::character varying, 'Operatore'::character varying]::text[])", name: "ruoli_nome_check"
    t.unique_constraint ["nome"], name: "ruoli_nome_key"
  end

  create_table "tipo_prodotto", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.text "descrizione"
    t.string "nome", limit: 50, null: false
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false

    t.check_constraint "nome::text = ANY (ARRAY['Buste'::character varying, 'Carta'::character varying, 'Toner'::character varying]::text[])", name: "tipo_prodotto_nome_check"
    t.unique_constraint ["nome"], name: "tipo_prodotto_nome_key"
  end

  create_table "utenti", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cognome", limit: 100
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.date "data_nascita"
    t.datetime "deleted_at", precision: nil
    t.string "email", limit: 255, null: false
    t.string "nome", limit: 100
    t.string "password_digest", limit: 255, null: false
    t.uuid "ruolo_id"
    t.string "stato_account", limit: 20, default: "Attivo", null: false
    t.integer "tentativi_login_falliti", default: 0, null: false
    t.datetime "ultimo_login", precision: nil
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
    t.string "username", limit: 100, null: false

    t.check_constraint "stato_account::text = ANY (ARRAY['Attivo'::character varying, 'Bloccato'::character varying]::text[])", name: "utenti_stato_account_check"
    t.unique_constraint ["email"], name: "utenti_email_key"
    t.unique_constraint ["username"], name: "utenti_username_key"
  end

  add_foreign_key "log_accessi", "utenti", column: "utente_id", name: "log_accessi_utente_id_fkey"
  add_foreign_key "movimenti_magazzino", "prodotti", column: "prodotto_id", name: "movimenti_magazzino_prodotto_id_fkey"
  add_foreign_key "movimenti_magazzino", "utenti", column: "utente_operazione_id", name: "movimenti_magazzino_utente_operazione_id_fkey"
  add_foreign_key "notifiche_email", "utenti", column: "utente_id", name: "notifiche_email_utente_id_fkey"
  add_foreign_key "prodotti", "tipo_prodotto", name: "prodotti_tipo_prodotto_id_fkey"
  add_foreign_key "prodotti", "utenti", column: "creato_da", name: "prodotti_creato_da_fkey"
  add_foreign_key "recupero_password", "utenti", column: "utente_id", name: "recupero_password_utente_id_fkey"
  add_foreign_key "utenti", "ruoli", column: "ruolo_id", name: "utenti_ruolo_id_fkey"
end
