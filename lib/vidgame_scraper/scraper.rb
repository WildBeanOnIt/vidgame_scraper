class VidgameScraper::Scraper

    def self.scrape_all_items(url)
        #open the url and scrape all the items ps4,ps5 etc.ur
        # url =" https://austin.craigslist.org/#{type}"
        webpage = Nokogiri::HTML(open(url))
        section = webpage.css(".rows").css(".result-row").css(".result-info").css(".result-heading")
        array_of_links = section.css("h3 a.hdrlnk")

        array_of_links.map do |link|
            VidgameScraper::Category.new(link.text, link.attributes["href"].value)
        end
            # binding.pry
        #will return a list of the items for sale?? 
    end

    def self.scrape_items(category)
        webpage = Nokogiri::HTML(open(category.url))
        items = webpage.css(".body")
        items.each do |card|
            # binding.pry

            deal = VidgameScraper::Deal.new

            
            title = card.css("#titletextonly").text.strip #shows the title of the item.
            price = card.css(".price").text
            location = card.css("h1.postingtitle").css("span.postingtitletext").css("small").text.strip  #shows the date when posted.
            
            time_posted = card.css("#display-date").css("time").text.strip.split(" ")[0]
            
            condition = card.css("p.attrgroup").text.gsub("  ","").gsub("\n", "")

            # first_condition = card.css("p.attrgroup span").children[0].text.strip # => "condition: "
            if card.css("p.attrgroup span").children[0]
                first_condition = card.css("p.attrgroup span").children[0].text.strip
            else
                first_condition = "Condition:"
            end
            
            # sec_condition = card.css("p.attrgroup span").children[1].text.strip # => "new"
            if card.css("p.attrgroup span").children[1]
                sec_condition = card.css("p.attrgroup span").children[1].text.strip
            else
                sec_condition = "Not listed."
            end

            if card.css("p.attrgroup span").children[4] # check if selector exists
                number_condition_left = card.css("p.attrgroup span").children[4].text.strip # get text of element
            else
                number_condition_left = "Model Name / Number:" # element did not exist
            end


            # number_condition_right = card.css("p.attrgroup span").children[5] ? card.css("p.attrgroup span").children[5].text.strip :  #"Where it was made from" (2b/2b)
            if card.css("p.attrgroup span").children[5]
                number_condition_right = card.css("p.attrgroup span").children[5].text.strip
            else
                number_condition_right = "Not listed."
            end
            # if card.css("p.attrgroup span").children[5]
            
            # crypto = card.css("p.attrgroup span").children[0].text.strip # => "cryptocurrency ok"
            if card.css("p.attrgroup span").children[0]
                crypto = card.css("p.attrgroup span").children[0].text.strip
            else
                crypto = "Crypto Currency: Not listed"
            end

            # delivery = card.css("p.attrgroup span").children[1].text # => "delivery available"
            if card.css("p.attrgroup span").children[1]
                delivery = card.css("p.attrgroup span").children[1].text
            else
                delivery = "Delivery: Not listed."
            end

            # make = card.css("p.attrgroup span").children[2].text.strip # => "make / manufacturer:" (1a/2a)
            if card.css("p.attrgroup span").children[2]
                make = card.css("p.attrgroup span").children[2].text.strip
            else
                make = "Make / Manufacturer:"
            end
            
            # brand = card.css("p.attrgroup span").children[3].text.strip # => "microsoft" (2a/2a)
            if card.css("p.attrgroup span").children[3]
                brand = card.css("p.attrgroup span").children[3].text.strip
            else
                brand = "Not listed."
            end
            
            # dimensions_one = card.css("p.attrgroup span").children[6].text.strip # => "size / dimensions: 15,75x18.1x31.5"
            if card.css("p.attrgroup span").children[6]
                dimensions_one = card.css("p.attrgroup span").children[6].text.strip
            else
                dimensions_one = "Size / Dimensions:"
            end

            # dimensions_two = card.css("p.attrgroup span").children[7].text.strip # => "15,75x18.1x31.5"
            if card.css("p.attrgroup span").children[7]
                dimensions_two = card.css("p.attrgroup span").children[7].text.strip
            else
                dimensions_two = "Size Not listed."
            end
            
            description = card.css("#postingbody").inner_text.gsub("  ", "").gsub("QR Code Link to This Post", "").gsub("\n", "").gsub("-", " -") #shwos desc.
            notice = card.css("ul.notices").css("li").text # shows the bullet point desc.
            # # post_id = card.css("div.postinginfos").css("p.postinginfo").children[0].text
            post_id = card.css("div.postinginfos").css("p.postinginfo").children[0].text.split(":")[0]
            num_id = card.css("div.postinginfos").css("p.postinginfo").children[0].text.split(":")[1].strip
            
            # ########deal#########

            deal.title = title
            deal.price = price
            deal.location = location
            deal.first_condition = first_condition
            deal.sec_condition = sec_condition
            deal.number_condition_left = number_condition_left
            deal.number_condition_right = number_condition_right
            deal.make = make
            deal.brand = brand
            deal.crypto = crypto
            deal.delivery = delivery
            deal.time_posted = time_posted
            deal.post_id = post_id
            deal.num_id = num_id
            deal.notice = notice
            deal.description = description
            deal.dimensions_two = dimensions_two
            deal.dimensions_one = dimensions_one

            category.add_deal(deal)
            # binding.pry
        end
    end
end

    #link.attributes["href"].valu shows the URL



    #**  will show the price of the item being sold **
    # [25] pry(VidgameScraper::Scraper)> webpage.css(".body").css("h1.postingtitle").css(".price").text
    # => "$1"

    #** for any listed things on the page**
    # [37] pry(VidgameScraper::Scraper)> webpage.css("ul.notices").css("li").text
    # => "do NOT contact me with unsolicited services or offers"