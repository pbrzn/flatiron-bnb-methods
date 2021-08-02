class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date_1, date_2)
    self.listings.select do |listing|
      true if listing.reservations.all? {|res| res.checkout <= date_1.to_date || res.checkin >= date_2.to_date}
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.sort {|a,b| b.ratio <=> a.ratio }[0]
  end

  def self.most_res
    max = self.all.map {|city| city.listings.map {|l| l.reservations.count}.sum}.max
    self.all.find {|city| city.listings.map {|l| l.reservations.count}.sum == max}
  end

  def ratio
    amt_of_listings = self.listings.count
    amt_of_res = self.listings.map {|l| l.reservations.count}.sum
    ratio = amt_of_res - amt_of_listings
  end

end
