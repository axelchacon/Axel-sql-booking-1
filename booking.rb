require "pg"
require "terminal-table"
class Booking
    def initialize
        @db = PG.connect( dbname: 'booking' ) 
    end
    def start
        print_welcome
        print_menu
        action = nil
        until action == "exit"
            print "> "
            action, param = gets.chomp.split
            case action
            # when "1" then puts top_publishers_prueba
            when "1" then  top_publishers
            when "2" then  search_books(param)
            when "3" then  count_books(param)
            when "menu" then print_menu
            when "exit" then puts "Thank you for using booking"
            else puts "Invalid option"
            end
        end
    end
end
private
def print_welcome
    puts "Welcome to Booking"
    puts "Write 'menu' at any moment to print the menu again and 'exit' to quit"
  end

  def print_menu
    puts "---"
    puts "1. Top 5 publisher by annual revenue"
    puts "2. Search books by [title=string | author=string | publisher=string]"
    puts "3. Count books by [author | publisher | genre]"
    puts "---"
  end
#   def top_publishers_prueba 
#     result = @db.exec("SELECT * FROM authors");
#     # p result.fields
#     # p result.values
#     table = Terminal::Table.new
#     table.title ="Authors"
#     table.headings = result.fields
#     table.rows = result.values
#     puts table
#   end
  def top_publishers
    result = @db.exec("SELECT * FROM publishers ORDER BY annual_revenue DESC LIMIT 5");
    table = Terminal::Table.new
    table.title ="Top Publishers by Annual Revenue"
    table.headings = result.fields
    table.rows = result.values
    puts table
  end
  def search_books(param)
    # nos mandan "title=terrible" por liro
    column_ref ={
      "title" => "b.title",
      "author" => "a.name",
      "publisher" => "p.name"
    }
    column, query = param.split('=')
    column = column_ref[column]
    # result = @db.exec(%[SELECT * FROM books WHERE LOWER(#{column}) LIKE '%#{query.downcase}%']);
    result = @db.exec(%[SELECT b.title, b.pages, a.name AS author, p.name AS publisher FROM books AS b JOIN authors AS a ON a.id = b.author_id JOIN publishers AS p ON p.id = b.publisher_id WHERE LOWER(#{column}) LIKE '%#{query.downcase}%']) # WHERE LOWER(#{column}) LIKE '%#{query.downcase}: LOWER convierte todo el título del libro en minúscula sin modificar lo que muestra la tabla solo en este caso y con esto puedes hacer esto  2 title=TeRRible sin modificar el title en minúscula sino solo el nombre del título  ;
    #probar: SELECT LOWER(title) FROM books WHERE title LIKE '%Cover%';
    #probar: SELECT * FROM books WHERE LOWER(title) LIKE '%cover%';
    table = Terminal::Table.new
    table.title ="Search Books"
    table.headings = result.fields
    table.rows = result.values
    puts table
  end
  def count_books(param)
   
    case param
    when "author"
      result = @db.exec(%[
        SELECT a.name AS author, COUNT(*) AS count_books
        FROM books AS b
        JOIN authors AS a ON a.id = b.author_id
        GROUP BY author
        ORDER BY count_books DESC;
      ])
    when "publisher"
      result = @db.exec(%[
        SELECT p.name AS publisher, COUNT(*) AS count_books
        FROM books AS b
        JOIN publishers AS p ON p.id = b.publisher_id
        GROUP BY publisher
        ORDER BY count_books DESC;
      ])
      # SELECT p.name AS publisher, COUNT(*) AS count_books
      #   FROM publishers  AS p
      #   JOIN books  AS b ON p.id = b.publisher_id
      #   GROUP BY publisher
      #   ORDER BY count_books DESC;
    when "genre"
      result = @db.exec(%[
        SELECT g.genre, COUNT(*) AS count_books
        FROM books AS b
        JOIN books_genres AS bg ON b.id = bg.book_id
        JOIN genres AS g ON g.id = bg.genre_id
        GROUP BY genre
        ORDER BY count_books DESC;
      ])
    end

    table = Terminal::Table.new
    table.title = "Count Books"
    table.headings = result.fields
    table.rows = result.values
    puts table
  end
app = Booking.new
app.start