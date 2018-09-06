require_relative './player_interface'

class ComputerInterface < PlayerInterface

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
