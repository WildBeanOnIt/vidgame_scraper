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
            condition = card.css("p.attrgroup").text.gsub("  ","").gsub("\n", "")
            time_posted = date = card.css("#display-date").css("time").text.strip.split(" ")[0]
            first_condition = card.css("p.attrgroup span").first.children[0].text.strip # => "condition: "
            sec_condition = card.css("p.attrgroup span").first.children[1].text.strip # => "new"
            number_condition_left = card.css("p.attrgroup span").children[4].text.strip # => "model name / number:"
            number_condition_right = card.css("p.attrgroup span").children[5].text.strip # => "model name / number:"
            make = card.css("p.attrgroup span").children[2].text.strip
            brand = card.css("p.attrgroup span").children[3].text.strip
            description = card.css("#postingbody").inner_text.gsub("  ", "").gsub("QR Code Link to This Post", "").gsub("\n", "").gsub("-", " -") #shwos desc.
            notice = card.css("ul.notices").css("li").text # shows the bullet point desc.
            post_id = card.css("div.postinginfos").css("p.postinginfo").first.children[0].text
            #################
            deal.title = title
            deal.price = price
            deal.location = location
            deal.first_condition = first_condition
            deal.sec_condition = sec_condition
            deal.number_condition_left = number_condition_left
            deal.number_condition_right = number_condition_right
            deal.make = make
            deal.brand = brand
            deal.time_posted = time_posted
            deal.post_id = post_id
            deal.notice = notice
            deal.description = description

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