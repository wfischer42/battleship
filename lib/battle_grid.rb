require "./lib/ship"
require "./lib/coordinates"

class BattleGrid
  include Coordinates

  attr_reader :cells,
              :ships

  def initialize(size)
    @letters = []
    cells = make_cells(size)
    cells.map! {|coord| [coord, :water]}
    @cells = Hash[cells]
    @ships = []
  end

  def make_cells(size)
    alphabet = *("A".."Z")
    @letters = alphabet[0, size]
    numbers = *("1"..size.to_s)
    all_coordinates(@letters, numbers)
  end

  def overlap_any?(*coords)
    coords = coords.flatten.sort
    coord_1 = coords[0]
    coord_2 = coords[-1]
    @ships.any? do |ship|
      ship.overlap?(coord_1, coord_2)
    end
  end

  def in_bounds?(*coords)
    coords.flatten!
    coords.all? do |coord|
      @cells.keys.include?(coord)
    end
  end

  def place_ship(ship)
    coords = ship.coordinates
    if in_bounds?(coords) && !overlap_any?(coords)
      @ships << ship
      update_grid(coords, :ship)
      return ship
    end
  end

  def ships_afloat
    @ships.select do |ship|
      ship.floating?
    end
  end

  def update_grid(*coords, value)
    coords.flatten!
    coords.each do |coord|
      @cells[coord] = value
    end
  end

  def resolve_shot(coord)
    return [coord, nil] if (@cells[coord] == :miss) || (@cells[coord] == :hit)
    resolution = register_miss(coord) if @cells[coord] == :water
    resolution = register_hit(coord) if @cells[coord] == :ship
    return [coord, resolution].flatten
  end

  def register_hit(coord)
    @cells[coord] = :hit
    hit_ship = @ships.find do |ship|
      ship.resolve_shot(coord) == :hit
    end
    resolution = :hit
    if !hit_ship.floating?
      resolution = register_sunk(hit_ship)
      if ships_afloat.size == 0
        resolution = :gameover
      end
    end
    return resolution
  end

  def register_sunk(ship)
    ship.coordinates.each do |coord|
      @cells[coord] = :sunk
    end
    return [:sunk, ship.size]
  end

  def register_miss(coord)
    @cells[coord] = :miss
  end

  def unoccupied_cells
    @cells.select do |cell, value|
      value == :water
    end.keys
  end

  def valid_targets
    @cells.select do |cell, value|
      (value == :ship) || (value == :water)
    end.keys
  end

  def row(letter)
    row_cells = @cells.select do |cell, value|
      cell[0] == letter
    end
    row_cells.values
  end

  def all_rows
    @letters.map do |letter|
      row(letter)
    end
  end

  def masked_cells
    @cells.map do |cell, value|
      value = :water if value == :ship
      [cell, value]
    end.to_h
  end
end
