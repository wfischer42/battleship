require './lib/battle_grid'
require './lib/computer_interface'
require './lib/human_interface'

require 'pry';

class Game
  def self.begin(grid_size, ship_sizes)
    @ship_sizes = ship_sizes

    @players = {computer: {interface: ComputerInterface.new,
                           board: BattleGrid.new(grid_size)},
                human:    {interface: HumanInterface.new,
                           board: BattleGrid.new(grid_size)}}

    @turn = [:human, :computer].shuffle
    self.play
  end

  def self.human_interface
    @players[:human][:interface]
  end

  def self.play
    @players.each do |player, handler|
      place_ships(player, handler)
    end
    winner = game_loop
    human_interface.announce_conclusion(winner)
  end

  def self.place_ships(player, handler)
    @ship_sizes.each do |ship_size|
      update_all_boards
      coords = handler[:interface].get_placement(ship_size)
      ship = Ship.new(coords[0], coords[1])
      handler[:board].place_ship(ship)
    end
  end

  def self.update_all_boards
    @players.each do |player, handler|
      p_board = handler[:board].cells
      o_board = opponent_board(player)
      handler[:interface].update_boards(p_board, o_board)
    end
  end

  def self.opponent_board(player)
    opponent = opponent_of(player)
    opponent_handler = @players[opponent]
    opponent_handler[:board].masked_cells
  end

  def self.game_loop
    loop do
      resolution = player_turn
      return @turn[0] if resolution == :gameover
      update_game_state(resolution)
    end
  end

  def self.player_turn
    shot = current_player[:interface].get_shot
    other_player[:board].resolve_shot(shot)
  end

  def self.update_game_state(resolution)
    human_interface.announce_resolution(resolution)
    update_all_boards
    @turn.rotate!
  end

  def self.current_player
    @players[@turn[0]]
  end

  def self.other_player
    @players[@turn[1]]
  end

  def self.opponent_of(this_player)
    @players.keys.find do |player|
      player != this_player
    end
  end
end
