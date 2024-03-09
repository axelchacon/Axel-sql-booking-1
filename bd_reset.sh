dropdb booking
createdb booking
psql -d booking < create.sql
ruby insert_data.rb books.csv
psql -d booking 