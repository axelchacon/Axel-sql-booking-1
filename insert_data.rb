
###### Paso 1: sin llenar datos, sale vacío los datos######
#require "pg";
#conn = PG.connect( dbname: 'booking' ) #Paso 1: Nos conectamos a la base de datos usando Ruby
#result = conn.exec( "SELECT * FROM authors" ) #Paso 2: Podemos hacer llmadas a la base de datos
# p conn
# p result
#p result.fields #["id", "name", "nationality", "birthdate"]
#p result.values #[]

###### formas de string para que conn.exec( %[INSERT INTO "authors_book"(name) VALUES ('AXEL')] )  acepten tables con nombre como por ejemplo authors_book ######

#"Hola" = 'Hola' = %(Hola) = %("Hola") = %('Hola') = %["Hola"] = %['Hola']

###### Paso2 :  Estamos llenadno datos con conn.exec( %[INSERT INTO authors(name) VALUES ('AXEL')] )###########

#require "pg";
# conn = PG.connect( dbname: 'booking' ) 
# conn.exec( %[INSERT INTO authors(name) VALUES ('AXEL')] ) # el id no se necesita poner por ser una primar y se calcula automáticamnete, los demás datos dependiendo del caso se pueden poner 
# # el del caso de arriba de authors solo se puso name ya que habíamos definido el valor como no nulo y los demás sí pueden ser nulos
# result = conn.exec( "SELECT * FROM authors" ) 
# p result.fields #["id", "name", "nationality", "birthdate"]
# p result.values #[["1", "AXEL", nil, nil]]

###### Paso3 :  usando el CSV de nuesto arhcivo books.csv######
# require "pg";
# require "csv";

# conn = PG.connect( dbname: 'booking' ) 
# CSV.foreach("books.csv", headers: true) do |row|
#     # Paso 1 ####

#     # p row["author_name"]
#     # p row

#     # Paso 2 ####
#     author_data = {
#         "name" => row["author_name"],
#         "nationality" => row["author_nationality"],
#         "birthdate" => row["author_birthdate"]
#     }
#     p author_data
# end


###### Paso4 :  dejando casi listo con Ruby para añadir a la base de datos usando Ruby######

require "pg";
require "csv";

DB = PG.connect( dbname: 'booking' ) 
def create(table, data) # table= nombre de la tabla y date es los datos que vamos a llenar en la tabla
    ##### Paso1 #######
    # # DB.exec( %[INSERT INTO #{table}(name, nationality,birthdate ) VALUES (#{data})] )
    # DB.exec( %[INSERT INTO #{table}(#{data.keys.join(",")}) VALUES (#{data.values.map{|value| "'#{value}'"}.join(",")})])
    # # p %[INSERT INTO #{table}(#{data.keys.join(",")}) VALUES (#{data.values.map{|value| "'#{value}'"}.join(",")})]

    ##### Paso2 : evitar datos repetidos en las tablas por ejemplos SELECT * FROM authors para que no tenga datos repetidos  #######
    ##### Inicio: estos dos líneas de código sirven para no tener datos repetidos#####
    author = DB.exec(%[SELECT * FROM #{table} WHERE name = '#{data['name']}']).first #bota un nil si no hay o un registro si hay
    # # p autor # retorna hashe scomo  {"id"=>"1", "name"=>"Belia Grady", "nationality"=>"British", "birthdate"=>"1970-02-14"}
    return if author
    ##### Final: estos dos líneas de código sirven para no tener datos repetidos#####
    DB.exec( %[INSERT INTO #{table}(#{data.keys.join(",")}) VALUES (#{data.values.map{|value| "'#{value}'"}.join(",")})])

end
CSV.foreach("books.csv", headers: true) do |row|

    author_data = {
        "name" => row["author_name"],
        "nationality" => row["author_nationality"],
        "birthdate" => row["author_birthdate"]
    }
    create("authors", author_data)
    # p author_data
end