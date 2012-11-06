class Cell < ActiveRecord::Base

  attr_accessible :ship, :location, :hit, :board_id

  belongs_to :board

  def shoot
    update_attributes(:hit => (ship != nil))
    hit
  end

end
