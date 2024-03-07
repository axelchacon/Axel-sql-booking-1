dropdb booking
createdb booking
psql -d booking < create.sql
ruby insert_data.rb
psql -d booking 