# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_email_spider_session',
  :secret      => '3bfac303b4f5c89520ee2d9ada1cc8a14e78423b5e750189cebe357d13a807f36ddc87d8bcfa275f4e5757d546ba77ff3dabe4f5c5b3d787b25ad57330eae33c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
