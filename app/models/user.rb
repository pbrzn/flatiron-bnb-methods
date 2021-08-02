class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    reservations = self.listings.map {|l| l.reservations }.flatten
    guests = reservations.map {|r| r.guest }
  end

  def hosts
    listings = self.trips.map {|r| r.listing }.flatten
    hosts = listings.map {|l| l.host }
  end

  def host_reviews
    self.guests.map {|g| g.reviews }.flatten
  end

end
