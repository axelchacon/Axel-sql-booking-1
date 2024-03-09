
###### Paso 1: sin llenar datos, sale vacío los datos######
# require "pg";
# conn = PG.connect( dbname: 'bartra' ) #Paso 1: Nos conectamos a la base de datos usando Ruby
# result = conn.exec( "SELECT * FROM authors" ) #Paso 2: Podemos hacer llmadas a la base de datos
# p conn
# p result
# p result.fields #["id", "name", "nationality", "birthdate"]
# p result.values #[]

###### formas de string para que conn.exec( %[INSERT INTO "authors_book"(name) VALUES ('AXEL')] )  acepten tables con nombre como por ejemplo authors_book ######
# %[INSERT INTO "authors_book"(name, nationalty, brithday) VALUES ('AXEL', "peruana", "1992-05-28")]
# "Hola" = 'Hola' = %(Hola) = %("Hola") = %('Hola') = %["Hola"] = %['Hola']

###### Paso2 :  Estamos llenadno datos con conn.exec( %[INSERT INTO authors(name) VALUES ('AXEL')] )###########

# require "pg";
# conn = PG.connect( dbname: 'bartra' ) 
# conn.exec( %[INSERT INTO authors(name,nationality,birthdate  ) VALUES ('BARTRA 7', 'Ukrania', '1990-12-18')]) # el id no se necesita poner por ser una primar y se calcula automáticamnete, los demás datos dependiendo del caso se pueden poner 
# # el del caso de arriba de authors solo se puso name ya que habíamos definido el valor como no nulo y los demás sí pueden ser nulos
# result = conn.exec( "SELECT * FROM authors" ) 
# p result.fields #["id", "name", "nationality", "birthdate"]
# p result.values #[["1", "AXEL", nil, nil]]

###### Paso3 :  usando el CSV de nuesto arhcivo books.csv######
# require "pg";
# require "csv";

# conn = PG.connect( dbname: 'booking' ) 

# conn.exec( %[INSERT INTO authors(name) VALUES ('Jorge')] ) 
# CSV.foreach("books.csv", headers: true) do |row|
#     p row["author_birthdate"]
#     # p row
# end
# conn.exec( %[INSERT INTO authors(name) VALUES ('Jorge')] ) 
# result = conn.exec( "SELECT * FROM authors" ) 
# p result.fields #["id", "name", "nationality", "birthdate"]
# p result.values #[["1", "AXEL", nil, nil]]