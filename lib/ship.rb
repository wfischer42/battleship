class Ship
  attr_reader :coordinates

  def initialize(coordinate_1, coordinate_2)
    @coordinates = Ship.coordinates(coordinate_1, coordinate_1)

  end

  def self.coordinates(coordinate_1, coordinate_2)

  end
end
