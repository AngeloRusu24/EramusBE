# ERAMUS - Backend (EramusBE)

API REST sviluppata con Ruby on Rails 8 e PostgreSQL.

---

## Stack Tecnologico

- **Ruby on Rails 8** (API mode)
- **PostgreSQL** come database
- **JWT** per autenticazione (Access + Refresh Token)
- **Bcrypt** per hashing password
- **Kaminari** per paginazione
- **Rack-CORS** per gestione CORS

---

## Credenziali Admin

- **Username:** `admin`
- **Password:** `Admin123!`

---

## Struttura Cartelle

```
EramusBE/
├── .env                          ← variabili d'ambiente (non su GitHub)
├── Gemfile                       ← dipendenze Ruby
├── db/
│   └── schema.sql                ← schema PostgreSQL con tutte le tabelle
├── config/
│   ├── routes.rb                 ← definizione degli endpoint API
│   ├── database.yml              ← configurazione connessione PostgreSQL
│   └── initializers/
│       └── cors.rb               ← configurazione CORS per il frontend
└── app/
    ├── models/
    │   ├── utente.rb
    │   ├── ruolo.rb
    │   ├── prodotto.rb
    │   ├── tipo_prodotto.rb
    │   ├── movimento_magazzino.rb
    │   ├── log_accesso.rb
    │   ├── recupero_password.rb
    │   └── notifica_email.rb
    ├── controllers/
    │   ├── application_controller.rb     ← autenticazione JWT base
    │   └── api/v1/
    │       ├── auth_controller.rb        ← login, refresh, recupero password
    │       ├── utenti_controller.rb      ← CRUD utenti
    │       ├── prodotti_controller.rb    ← CRUD prodotti
    │       ├── movimenti_controller.rb   ← movimenti magazzino
    │       ├── dashboard_controller.rb   ← statistiche dashboard
    │       ├── tipo_prodotto_controller.rb
    │       └── ruoli_controller.rb
    ├── services/
    │   └── jwt_service.rb               ← generazione e validazione JWT
    └── mailers/
        └── utente_mailer.rb             ← email benvenuto e recupero password
```

---

## File .env

Crea il file `.env` nella root del progetto con:

```
DB_USERNAME=postgres
DB_PASSWORD=tuapassword
JWT_SECRET_KEY=eramus_jwt_secret_key_molto_lunga_2026
FRONTEND_URL=http://localhost:3000
```

> Il file `.env` è già nel `.gitignore` e non verrà mai caricato su GitHub.

---

## Setup da Zero

```bash
# 1. Entra nella cartella
cd EramusBE

# 2. Installa le gem
bundle install

# 3. Avvia PostgreSQL
sudo systemctl start postgresql

# 4. Crea il database
rails db:create

# 5. Esegui lo schema SQL
psql -U postgres -d eramus_be_development -f db/schema.sql

# 6. Avvia il server sulla porta 3001
rails s -p 3001
```

---

## Creare l'utente Admin

```bash
rails console
```

```ruby
Utente.create!(
  username: 'admin',
  email: 'admin@eramus.it',
  password: 'Admin123!',
  nome: 'Admin',
  cognome: 'Sistema',
  ruolo: Ruolo.find_by(nome: 'Admin')
)
```

---

## Riavvio dopo spegnimento PC

```bash
sudo systemctl start postgresql
cd ~/GitHub/Eramus/EramusBE
rails s -p 3001
```

---

## Endpoint API

| Metodo | URL | Descrizione | Auth |
|--------|-----|-------------|------|
| POST | /api/v1/auth/login | Login | No |
| POST | /api/v1/auth/refresh | Refresh token | No |
| POST | /api/v1/auth/forgot_password | Richiedi reset password | No |
| POST | /api/v1/auth/reset_password | Reset password | No |
| GET | /api/v1/dashboard | Dati dashboard | Sì |
| GET | /api/v1/utenti | Lista utenti | Admin |
| POST | /api/v1/utenti | Crea utente | Admin |
| PATCH | /api/v1/utenti/:id | Modifica utente | Admin |
| DELETE | /api/v1/utenti/:id | Disattiva utente (soft delete) | Admin |
| PATCH | /api/v1/utenti/:id/assign_role | Assegna ruolo | Admin |
| GET | /api/v1/prodotti | Lista prodotti | Sì |
| POST | /api/v1/prodotti | Crea prodotto | Sì |
| PATCH | /api/v1/prodotti/:id | Modifica prodotto | Sì |
| DELETE | /api/v1/prodotti/:id | Elimina prodotto (soft delete) | Sì |
| GET | /api/v1/movimenti | Lista movimenti | Sì |
| POST | /api/v1/movimenti | Crea movimento | Sì |
| GET | /api/v1/tipo_prodotto | Lista tipi prodotto | Sì |
| GET | /api/v1/ruoli | Lista ruoli | Sì |

---

## Funzionalità

- **JWT** con Access Token (15 min) e Refresh Token (7 giorni)
- **Blocco automatico** account dopo 5 tentativi di login falliti
- **Recupero password** via email con link temporaneo (valido 1 ora)
- **Log accessi** con IP e esito (Successo/Fallito)
- **Soft delete** su utenti e prodotti
- **Validazione password AGID**: min 8 caratteri, 1 maiuscola, 1 numero, 1 carattere speciale
- **Aggiornamento automatico quantità** prodotto ad ogni movimento magazzino
