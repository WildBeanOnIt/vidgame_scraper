class VidgameScraper::Category

    attr_accessor :name, :url

    @@all = []

    def initialize(name, url)
        @name = name
        # @url = "https://www.gamestop.com" + url #Gamestop test
        @url = "https://austin.craigslist.org" + url
        

        @@all << self   #saving the obj.

    end

    def self.all
        @@all
    end

end 