class Ship
  attr_reader :coordinates,
              :hits

  def initialize(coord_1, coord_2)
    @coordinates = Ship.coordinates(coord_1, coord_2)
    @hits = []
  end

  def overlap?(coord_1, coord_2)
    other_coords = Ship.coordinates(coord_1, coord_2)
    other_coords.any? do |other|
      @coordinates.include?(other)
    end
  end

  def floating?
    @coordinates.sort != @hits.sort
  end

  def resolve_shot(shot_coord)
    if @coordinates.include?(shot_coord)
      hits << shot_coord
      return :hit
    else
      return :miss
    end
  end

  def self.coordinates(coord_1, coord_2)
    letters = (coord_1[0]..coord_2[0]).to_a
    numbers = (coord_1[1]..coord_2[1]).to_a
    return nil if letters.length > 1 && numbers.length > 1
    pairs = letters.product(numbers)
    coordinates = pairs.map do |pair|
      pair.join
    end.sort
  end
end
