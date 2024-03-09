# def positive_number(x)
#     return if x <= 0
#     puts "El número es positivo: #{x}"
# end
  
#   positive_number(5)
#   positive_number(-3)

require "pg";
require "csv";

DB = PG.connect( dbname: 'booking' ) 
def create(table, data) # table= nombre de la tabla y date es los datos que vamos a llenar en la tabla
  
    author = DB.exec(%[SELECT * FROM #{table} WHERE name = '#{data['name']}']).first #bota un nil si no hay o un registro si hay
    # # p autor # retorna hashe scomo  {"id"=>"1", "name"=>"Belia Grady", "nationality"=>"British", "birthdate"=>"1970-02-14"}
    return  if author 
    puts author
   

    ##### Final: estos dos líneas de código sirven para no tener datos repetidos#####
    # DB.exec( %[INSERT INTO #{table}(#{data.keys.join(",")}) VALUES (#{data.values.map{|value| "'#{value}'"}.join(",")})])
    # puts %[INSERT INTO #{table}(#{data.keys.join(",")}) VALUES (#{data.values.map{|value| "'#{value}'"}.join(",")})]

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