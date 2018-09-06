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
    coords && coords.size == ship_size && !cells_occupied?(coords)
  end

  def cells_occupied?(coords)
    coords.any? do |coord|
      @player_board[coord] == :ship
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
end
