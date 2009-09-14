# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_globalquiver_session',
  :secret      => '6436123326cd3066db2c859beac3e8bfebd882b12e8082c46a8aa98420b659d25433c1c8ef0be61fe0dc45a8382a5a77655393ed42510220bd6594b187340c08'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
