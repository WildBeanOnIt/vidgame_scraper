class VidgameScraper::Category

    attr_accessor :name, :url
    attr_reader :deals

    @@all = []

    def initialize(name, url)
        @name = name
        @url = url
        @deals = []
        @@all << self   #saving the obj.
    end

    def self.all
        @@all
    end

    # def self.type(type)
    #     @@all.select{|category| category.type == type}
    # end

    def add_deal(deal)
        self.deals << deal
        deal.category = self
    end


end