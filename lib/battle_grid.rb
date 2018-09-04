require "./lib/ship"
require "./lib/coordinates"

class BattleGrid
  include Coordinates

  attr_reader :cell_list,
              :fleet

  def initialize(size)
    @cell_list = make_cells(size)

    # empty_row = Hash.new(:water)
    @cell_grid = Hash.new([:water, size])
    @fleet = []
  end

  def make_cells(size)
    alphabet = *("A".."Z")
    letters = alphabet[0, size]
    numbers = *("1"..size.to_s)
    all_coordinates(letters, numbers)
  end

  def cell_grid(coord)
    return nil if !@cell_list.include?(coord)
    c = unpack_coordinate(coord)
    @cell_grid[c[0]][c[1]]
  end

  def in_bounds?(*coords)
    coords.flatten!
    coords.all? do |coord|
      @cell_list.include?(coord)
    end
  end

  def place_ship(ship)
    coords = ship.coordinates
    if in_bounds?(coords)
      @fleet << ship
      update_grid(coords, :unhit)
      return ship
    end
  end

  def update_grid(*coords, value)
    coords.flatten!
    coords.each do |coord|
      c = unpack_coordinate(coord)
      @cell_grid[c[0]][c[1]] = value
    end
  end

  def resolve_shot(coords)

  end
end
