class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validates :reservation, presence: true, if: [Proc.new {|r| r.reservation.present?}, :checked_out, :status?]

  def checked_out
    if self.reservation.checkout >= Date.today
      errors.add(:reservation, "You have not checked out yet")
    end
  end

  def status?
    if self.reservation.status != "accepted"
      errors.add(:reservation, "You reservation has not been accepted as of now.")
    end
  end

end
