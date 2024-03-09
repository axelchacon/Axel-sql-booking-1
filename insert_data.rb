
require "pg";
require "csv";

cvs_file = ARGV[0]
DB = PG.connect( dbname: 'booking' ) 
def create(table, data,unique_column) # table= nombre de la tabla y date es los datos que vamos a llenar en la tabla
    # p unique_column
    # p data[unique_column]
    entity = unique_column.nil?  ? nil :  find(table,unique_column,data[unique_column]) 
    return entity if entity ###Significa que retorna de nuevo la función create si author ya existe o es true, por ejemplo para el primer author guarda su valor y si otra vez se repite se vuelve true 
    DB.exec( %[INSERT INTO #{table}(#{data.keys.join(",")}) VALUES (#{data.values.map{|value| "'#{value.gsub("'","''")}'"}.join(",")}) RETURNING *]).first
end
def find(table, column, value)
    DB.exec(%[SELECT * FROM #{table} WHERE #{column} = '#{value.gsub("'","''")}']).first
end
CSV.foreach(cvs_file, headers: true) do |row|

    author_data = {
        "name" => row["author_name"],
        "nationality" => row["author_nationality"],
        "birthdate" => row["author_birthdate"]
    }
     author = create("authors", author_data, 'name')  

     
    publisher_data = {
        "name" => row["publisher_name"],
        "annual_revenue" => row["publisher_annual_revenue"],
        "founded_year" => row["publisher_founded_year"]
    }
    publisher = create("publishers", publisher_data, 'name') 
    genre_data = {
        "genre" => row["genre"],
    }
    genre = create("genres", genre_data, 'genre') # devuelve {"id": 1, "genre": ""Science fictio"}
     #### Para termnar de inserdatas las demás tablas empieza en 54 min:20 min y termina 1h:10min: Worshop1
     book_data = {
        "title" => row["title"],
        "pages" => row["pages"],
        "author_id" => author["id"],
        "publisher_id" => publisher["id"],
    }
     book = create("books", book_data, 'title') 
    book_genre_data = {
        "genre_id" => genre["id"],
        "book_id" => book["id"]
    }  
    create("books_genres", book_genre_data, nil)
end

