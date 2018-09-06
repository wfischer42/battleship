require "./lib/coordinates"

class Ship
  include Coordinates

  attr_reader :coordinates,
              :hits

  def initialize(coord_1, coord_2)
    @coordinates = full_coordinates(coord_1, coord_2)
    @hits = []
  end

  def overlap?(coord_1, coord_2)
    other_coords = full_coordinates(coord_1, coord_2)
    other_coords.any? do |other|
      @coordinates.include?(other)
    end
  end

  def floating?
    @coordinates.sort != @hits.sort
  end

  def size
    @coordinates.size
  end

  def resolve_shot(shot_coord)
    if @coordinates.include?(shot_coord)
      hits << shot_coord
      return :hit
    else
      return :miss
    end
  end
end
