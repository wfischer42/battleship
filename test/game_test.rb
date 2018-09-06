require 'minitest/autorun'
require 'minitest/pride'

require './lib/game'

class GameTest < Minitest::Test
  def test_it_exists
    game = Game.new
    assert_instance_of Game, game
  end

  def test_it_has_5x5_grids_by_default
    game = Game.new
    assert_instance_of BattleGrid, game.grids[:player]
    assert_instance_of BattleGrid, game.grids[:computer]
    assert_equal 16, game.grids[:player].cells.size
  end
end
