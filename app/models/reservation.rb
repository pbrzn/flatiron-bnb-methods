class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :same_user?
  validate :in_before_out?
  validate :available?


  def same_user?
    if self.guest == self.listing.host
      errors.add(:guest, "cannot also be the host")
    end
  end

  def in_before_out?
    if self.checkin >= self.checkout
      errors.add(:checkin, "Checkin must be an earlier date than checkout")
    end
  end

  def available?
    if !self.listing.reservations.all? {|r| r.checkout <= self.checkin || r.checkin >= self.checkout }
      errors.add(:listing, "is unavailable at the requested dates")
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * self.duration
  end

end
