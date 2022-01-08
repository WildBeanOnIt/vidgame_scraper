class VidgameScraper::CLI
    # attr_reader :counter, :type

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
            puts "\nChoose which Item you want to see the deals for:".colorize(:green)
            #lists items
            #responds to user input when they choose a category

        categories.each.with_index(1) do |category, index|
            puts "#{index}. #{category.name}"
        end
    end

    def choose_item
        puts "\nChoose a Item by typing a number:"
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
        
        if category.deals.empty?
            VidgameScraper::Scraper.scrape_items(category)
        end

        puts "Here are the deals for #{category.name}:\n"
        # binding.pry
        category.deals.each.with_index(1) do |deal, index|
            
            puts "\nItem Name: #{deal.title}"
            puts "Price: #{deal.price}"

            puts "-- Location being worked on --"
            
            if "#{deal.location}" == "#{deal.location}"
                puts "Location: #{deal.location}"
            else
                puts "Location: No location was listed"
            end


            puts "#{deal.first_condition} #{deal.sec_condition}"
            puts "#{deal.make} #{deal.brand}"
            puts "#{deal.number_condition_left} #{deal.number_condition_right}"
            puts "Posted in (yyyy/mm/dd): #{deal.time_posted}"
            puts "#{deal.post_id}"
            puts "Description: #{deal.description}"
            puts "Notce: #{deal.notice}"
            end
            puts "\n"
        end
    end

    def sub_out 
        puts "Would you like to see the Menu again?".colorize(:white) + " (" + "'y'".colorize(:green) + "/" + "'n'".colorize(:red) + ")" 
        answers = gets.strip.downcase
        case answers
        when "y"
            menu
        when "n"
            exit_program
        else
            puts "Invalid input. Please try again".colorize(:red)
            sub_out
        end
    end

    def exit_program
        puts "Thank you for visiting! Goodbye.".colorize(:red)
    end
