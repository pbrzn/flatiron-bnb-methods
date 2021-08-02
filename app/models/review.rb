class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validates :reservation, presence: true
  validate :checked_out?
  validate :status?

  def checked_out?
    return if self.reservation.nil?
    if self.reservation.checkout >= Date.today
      errors.add(:reservation, "You have not checked out yet")
    end
  end

  def status?
    return if self.reservation.nil?
    if self.reservation.status != "accepted"
      errors.add(:reservation, "You reservation has not been accepted as of now.")
    end
  end

end
