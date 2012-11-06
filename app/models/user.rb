class User < ActiveRecord::Base
  attr_accessible :name
  has_many :boards
  has_many :games, :through => :boards
end
