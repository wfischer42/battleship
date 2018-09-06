require './lib/coordinates.rb'

class PlayerInterface
  include Coordinates

  def update_boards(player_board, opponent_board)
    @player_board = player_board
    @opponent_board = opponent_board
  end

  def valid_placement?(coords, ship_size)
    return false if coords.length != 2
    coords = full_coordinates(coords[0], coords[1])
    right_size = (coords && coords.size == ship_size)
    right_size && in_bounds?(coords) && !cells_occupied?(coords)
  end

  def cells_occupied?(coords)
    coords.any? do |coord|
      @player_board[coord] == :ship
    end
  end

  def in_bounds?(coords)
    coords.flatten!
    coords.all? do |coord|
      @player_board.keys.include?(coord)
    end
  end

  def valid_cells(board)
    board.select do |cell, value|
      value == :water
    end.keys
  end

  def valid_target?(coord)
    valid_cells(@opponent_board).include?(coord)
  end

  # Comment out these to allow human player to inherit auto behavior & simulate a game
  def take_turn
    valid_cells(@opponent_board).sample
  end

  def get_placement(ship_size)
    loop do
      coords = valid_cells(@player_board).sample(2)
      return coords if valid_placement?(coords, ship_size)
    end
  end
end
