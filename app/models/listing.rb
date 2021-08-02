class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  before_create :change_host_status
  around_destroy :change_host_status

  def average_review_rating
    ratings = self.reviews.map {|rev| rev.rating }
    avg = ratings.sum.to_f / ratings.length.to_f
  end

  def change_host_status
    host = self.host
    if !host.host?
      host.update(host: true)
    elsif host.listings.length == 0
      host.update(host: false)
    end
  end

end
