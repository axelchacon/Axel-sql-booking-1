-- empeamos con los extremos como authors
CREATE TABLE authors(
id SERIAL PRIMARY KEY,
name VARCHAR NOT NULL, 
nationality VARCHAR, 
birthdate DATE
)

CREATE TABLE publishers(
id SERIAL PRIMARY KEY,
name VARCHAR NOT NULL, 
annual_revenue INTEGER, 
founded_year INTEGER
)

CREATE TABLE books(
id SERIAL PRIMARY KEY,
title VARCHAR NOT NULL, 
pages INTEGER NOT NULL CHECK(pages>0), 
author_id INTEGER NOT NULL REFERENCES authors(id),
publisher_id INTEGER NOT NULL REFERENCES publishers(id)
)

CREATE TABLE genres(
id SERIAL PRIMARY KEY,
genre VARCHAR
)

CREATE TABLE books_genres(
id SERIAL PRIMARY KEY,
genre_id INTEGER NOT NULL REFERENCES genres(id),
book_id INTEGER NOT NULL REFERENCES books(id)
)