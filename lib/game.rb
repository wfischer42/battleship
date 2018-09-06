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
    @turns = 0
    play
  end

  # TODO: Send "Sunk" message when ship sinks
  # TODO: Pause after player turn
  # TODO: Unicode emojis
=begin
  U+1F4A5	explosion
  U+1F4A6 splash
  U+1F30A	wave
  U+1F6A4	boat
  U+2620	skull & crossbones
=end

  def self.human_interface
    @players[:human][:interface]
  end

  def self.play
    setup_turns
    update_all_boards
    human_interface.announce_commencement
    @players.each do |player, handler|
      place_ships(handler)
    end
    human_interface.announce_first_player(@this_player)
    winner = game_loop
    human_interface.announce_conclusion(winner, @turns)
  end

  def self.setup_turns
    turn = @players.keys.shuffle
    @this_player = turn[0]
    @next_player = turn[1]
  end

  def self.place_ships(handler)
    @ship_sizes.each do |ship_size|
      coords = handler[:interface].get_placement(ship_size)
      ship = Ship.new(coords[0], coords[1])
      result = handler[:board].place_ship(ship)
      update_all_boards
      human_interface.announce_commencement
    end
  end

  def self.place_ship(handler, ship_size)
    coords = handler[:interface].get_placement(ship_size)
    ship = Ship.new(coords[0], coords[1])
    handler[:board].place_ship(ship)
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
    @turns += 1
    loop do
      resolution = player_turn
      update_game_state(resolution)
      return @this_player if resolution[1] == :gameover
      rotate_turns
    end
  end

  def self.player_turn
    shot_coords = @players[@this_player][:interface].take_turn
    @players[@next_player][:board].resolve_shot(shot_coords)
  end

  def self.update_game_state(resolution)
    update_all_boards
    human_interface.announce_resolution(@this_player, resolution)
  end

  def self.rotate_turns
    @this_player, @next_player = @next_player, @this_player
    @turns += 1
  end

  def self.opponent_of(this_player)
    @players.keys.find do |player|
      player != this_player
    end
  end
end
