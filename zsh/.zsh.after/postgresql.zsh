# We need Postgres 13 for the Apartment Snapshot Platform project but brew does
# not add it to our path since it conflicts with the default Postgres 14.
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
