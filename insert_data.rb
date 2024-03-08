
require "pg";
require "csv";

DB = PG.connect( dbname: 'booking' ) 
def create(table, data,unique_column) # table= nombre de la tabla y date es los datos que vamos a llenar en la tabla
    # p unique_column
    # p data[unique_column]
    author = find(table,unique_column,data[unique_column]) 
    return if author ###Significa que retorna de nuevo la función create si author ya existe o es true, por ejemplo para el primer author guarda su valor y si otra vez se repite se vuelve true 
    DB.exec( %[INSERT INTO #{table}(#{data.keys.join(",")}) VALUES (#{data.values.map{|value| "'#{value.gsub("'","''")}'"}.join(",")})])
end
def find(table, column, value)
    DB.exec(%[SELECT * FROM #{table} WHERE #{column} = '#{value.gsub("'","''")}']).first
end
CSV.foreach("books.csv", headers: true) do |row|

    author_data = {
        "name" => row["author_name"],
        "nationality" => row["author_nationality"],
        "birthdate" => row["author_birthdate"]
    }
     create("authors", author_data, 'name')  

     
    publisher_data = {
        "name" => row["publisher_name"],
        "annual_revenue" => row["publisher_annual_revenue"],
        "founded_year" => row["publisher_founded_year"]
    }
     create("publishers", publisher_data, 'name') 
    genre_data = {
        "genre" => row["genre"],
    }
     create("genres", genre_data, 'genre')
    #  book_data = {
    #     "title" => row["publisher_name"],
    #     "annual_revenue" => row["publisher_annual_revenue"],
    #     "founded_year" => row["publisher_founded_year"]
    # }
    #  create("publishers", publisher_data, 'name')   
end

