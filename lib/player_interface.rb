require './lib/coordinates.rb'

class PlayerInterface
  include Coordinates

  def initialize
    @shot_sequence = ["A1", "C1", "A2", "B3", "B1", "C3", "B2"]
  end

  def update_boards(player_board, opponent_board)
    @player_board = player_board
    @opponent_board = opponent_board
  end

  def valid_placement?(coord_1, coord_2, ship_size)

  end

  # TODO: override these test method in the interfaces
  def get_placement(ship_size)
    return ["A1", "A2"] if ship_size == 2
    return ["B1", "B3"] if ship_size == 3
  end

  def get_shot
    @shot_sequence.shift
  end

  def announce_resolution(resolution)
    puts "It was a #{resolution.to_s}!"
  end

  def announce_conclusion(winner)
    puts "The #{winner.to_s} won!"
  end
end
