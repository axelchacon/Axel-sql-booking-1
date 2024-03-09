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
            action = gets.chomp
            case action
            # when "1" then puts top_publishers_prueba
            when "1" then puts top_publishers
            when "2" then puts "Option 2"
            when "3" then puts "Option 3"
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
app = Booking.new
app.start