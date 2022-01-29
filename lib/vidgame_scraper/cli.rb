class VidgameScraper::CLI

    def start   #instance method
        puts "\n         Welcome to my".colorize(:white) +  " CLI!".colorize(:blue)
        menu
    end

    def menu
        puts "Want to see what Video Games are for sale?".colorize(:white)
        puts " \nPress [1] to see the list.".colorize(:white)
        

        input = gets.strip.downcase
        case input
        when "1"
            puts "In".colorize(:white) + " Video Games ↓".colorize(:green)
            # @type = "Video Games"
            scrape_video_game
            list_items
            choose_item            
            # sub_out #loop if user want to continue            
        when "exit"
            puts "Goodbye, Thank you for visiting!".colorize(:red)
        else
            puts "Sorry invalid answer".colorize(:red)
            sub_out
            
            #they input something incorrect
        end
    end
    
    def scrape_video_game
        url = "https://austin.craigslist.org/d/video-gaming/search/vga"
        categories = VidgameScraper::Scraper.scrape_all_items(url)
    end

    def list_items
        categories = VidgameScraper::Category.all
            puts "\nChoose which Item you want to see more info about:".colorize(:green)
            puts "\n"
            #responds to user input when they choose a category
        categories.each.with_index(1) do |category, index|
            # sleep 1
            puts "#{index}. #{category.name}"
        end
    end

    def choose_item
        puts "\nChoose a Item by typing a number:".colorize(:green)
        input = gets.strip.to_i
        # VidgameScraper::Category.all.length
        max_value = VidgameScraper::Category.all.length
        if input.between?(1, max_value) #starts from 1 - the max #listed
            category = VidgameScraper::Category.all[input-1]
            display_category_items(category)
            #valid input
        else
            #not valid input
            list_items
            puts "\nPlease put in a valid input".colorize(:red)
            choose_item
        end
    end

    def display_category_items(category)    #once they pick the item
        puts "\nOne moment please while the code loads...".colorize(:green)
        puts "\n"
        # sleep 1
        if category.deals.empty?
            VidgameScraper::Scraper.scrape_items(category)
        end
            puts "Here are the deals for " + "#{category.name}:\n".colorize(:yellow)
            # binding.pry
            category.deals.each.with_index(1) do |deal, index|
                puts "\nItem Name:".colorize(:blue) + " #{deal.title}"
                    # => Item name: XYZ
                puts "Price:".colorize(:blue) + " #{deal.price}"
                    # => Price : 00
                # - -- - -- - -- - - -- - -- - - -- - - -- - - - -- - -- - -- -
                # puts "Location: #{deal.location}" 
                if "#{deal.location}" == ""
                    puts "Location:".colorize(:yellow) + " Not listed.".colorize(:red)
                else
                    puts "Location:".colorize(:blue) + " #{deal.location}"
                end
                # => (location)
                # - -- - -- - -- - - -- - -- - - -- - - -- - - - -- - -- - -- -
                
                puts "#{deal.first_condition}".colorize(:blue) + " #{deal.sec_condition}"
                # => "Condition: ABC"
                # - -- - -- - -- - - -- - -- - - -- - - -- - - - -- - -- - -- -
                # puts "#{deal.make}".colorize(:blue) + " #{deal.brand}"
                if "#{deal.make}" == ""
                    puts "Make / Manufacturer:".colorize(:yellow) + " Not listed."
                else
                    puts "#{deal.make}".colorize(:blue) + " #{deal.brand}"
                end
                
                puts "#{deal.number_condition_left}".colorize(:blue) + " #{deal.number_condition_right}"
                
                puts "#{deal.dimensions_one}".colorize(:blue) + " #{deal.dimensions_two}"
                
                puts "Posted in (yyyy/mm/dd):".colorize(:blue) + " #{deal.time_posted}"
                
                puts "#{deal.post_id}:".capitalize.colorize(:blue) + " #{deal.num_id}"
                
                puts "Description:".colorize(:blue) + " #{deal.description}"
                
                puts "Notce:".colorize(:red) + " #{deal.notice}"

                
                puts "\n"
                show_list_again
            end
        end
    end

    def sub_out 
        puts "Would you like to see the Menu again?".colorize(:white) + " (" + "'y'".colorize(:green) + "/" + "'n'".colorize(:red) + ")" 
        answers = gets.strip.downcase
        case answers
        when "y"
            menu
            choose_item
        when "n"
            exit_program
        else
            puts "Invalid input. Please try again".colorize(:red)
            sub_out
        end
    end
    
    def show_list_again 
        puts "Would you like to see the Menu again?".colorize(:white) + " (" + "'y'".colorize(:green) + "/" + "'n'".colorize(:red) + ")" 
        answers = gets.strip.downcase
        case answers
        when "y"
            list_items
            choose_item
        when "n"
            exit_program
        else
            puts "Invalid input. Please try again".colorize(:red)
            sub_out
        end
    end
    
    def exit_program
        puts "Thank you for Visiting! Goodbye.".colorize(:red)
    end
