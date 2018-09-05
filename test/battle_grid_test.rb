require 'minitest/autorun'
require 'minitest/pride'

require './lib/battle_grid'

class BattleGridTest < Minitest::Test
  def test_it_exits
    p1_grid = BattleGrid.new(10)
    assert_instance_of BattleGrid, p1_grid
  end

  def test_it_has_cells
    p1_grid = BattleGrid.new(2)
    assert_equal ["A1", "A2", "B1", "B2"], p1_grid.cells.keys
  end

  def test_it_determines_if_coordinates_are_in_bounds
    p1_grid = BattleGrid.new(5)
    assert p1_grid.in_bounds?("A3", "A5")
    refute p1_grid.in_bounds?("A1", "M1")
  end

  def test_cells_are_empty_by_default
    p1_grid = BattleGrid.new(2)
    assert_equal :water, p1_grid.cells["A1"]
    assert_equal :water, p1_grid.cells["B2"]
  end

  def test_it_returns_nil_for_invalid_cells
    p1_grid = BattleGrid.new(2)
    assert_nil p1_grid.cells["C3"]
  end

  def test_it_has_no_ships_in_ships_by_default
    p1_grid = BattleGrid.new(5)
    assert_equal [], p1_grid.ships
  end

  def test_it_can_place_ships
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A4")
    ship_2 = Ship.new("B3", "C3")

    p1_grid.place_ship(ship_1)
    p1_grid.place_ship(ship_2)

    assert_equal [ship_1, ship_2], p1_grid.ships
  end

  def test_it_can_list_unoccupied_cells_for_ship_placement
    p1_grid = BattleGrid.new(3)
    ship_1 = Ship.new("A1", "A3")
    ship_2 = Ship.new("B3", "C3")

    p1_grid.place_ship(ship_1)
    p1_grid.place_ship(ship_2)

    expected = ["B1", "B2", "C1", "C2"]
    assert_equal expected, p1_grid.unoccupied_cells
  end

  def test_it_can_determine_if_new_ship_will_overlap_existing_ship
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A4")
    p1_grid.place_ship(ship_1)

    overlap_1 = p1_grid.overlap_any?("A2", "B2")
    overlap_2 = p1_grid.overlap_any?("B2", "D2")

    assert overlap_1
    refute overlap_2
  end

  def test_it_wont_place_ships_if_coordinates_overlap
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A4")
    ship_2 = Ship.new("A2", "C2")

    p1_grid.place_ship(ship_1)
    nil_result = p1_grid.place_ship(ship_2)

    assert_nil nil_result
    assert_equal [ship_1], p1_grid.ships
  end

  def test_it_doesnt_place_ships_out_of_bounds
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A9")
    ship_2 = Ship.new("A3", "C3")

    nil_result = p1_grid.place_ship(ship_1)
    ship_result = p1_grid.place_ship(ship_2)

    assert_nil nil_result
    assert_equal ship_2, ship_result
    assert_equal [ship_2], p1_grid.ships
  end

  def test_cells_store_ship_locations
    p1_grid = BattleGrid.new(5)
    ship = Ship.new("A1", "A4")
    p1_grid.place_ship(ship)

    assert_equal :ship, p1_grid.cells["A2"]
    assert_equal :ship, p1_grid.cells["A4"]
    assert_equal :water, p1_grid.cells["B4"]
  end

  def test_it_can_determine_if_a_shot_hits
    p1_grid = BattleGrid.new(5)
    ship = Ship.new("A1", "A4")
    p1_grid.place_ship(ship)

    shot_1 = p1_grid.resolve_shot("B2")
    shot_2 = p1_grid.resolve_shot("A2")

    assert_equal :miss, shot_1
    assert_equal :hit, shot_2
  end

  def test_registers_hit_with_ship
    p1_grid = BattleGrid.new(5)
    ship = Ship.new("A1", "A4")
    p1_grid.place_ship(ship)

    shot_2 = p1_grid.resolve_shot("A2")
    assert_equal ["A2"], p1_grid.ships[0].hits
  end

  def test_cells_store_hit_locations
    p1_grid = BattleGrid.new(5)
    ship = Ship.new("A1", "A3")
    p1_grid.place_ship(ship)

    p1_grid.resolve_shot("A2")

    assert_equal :hit, p1_grid.cells["A2"]
    assert_equal :ship, p1_grid.cells["A1"]
    assert_equal :water, p1_grid.cells["B3"]
  end

  def test_cells_store_miss_locations
    p1_grid = BattleGrid.new(5)
    ship = Ship.new("A1", "A3")
    p1_grid.place_ship(ship)

    p1_grid.resolve_shot("B4")

    assert_equal :ship, p1_grid.cells["A2"]
    assert_equal :miss, p1_grid.cells["B4"]
  end

  def test_it_can_list_valid_target_cells
    p1_grid = BattleGrid.new(3)
    ship_1 = Ship.new("A1", "A3")
    ship_2 = Ship.new("B2", "C2")

    p1_grid.place_ship(ship_1)
    p1_grid.place_ship(ship_2)

    p1_grid.resolve_shot("A3")
    p1_grid.resolve_shot("B1")
    p1_grid.resolve_shot("C2")
    p1_grid.resolve_shot("C3")

    expected = ["A1", "A2", "B2", "B3", "C1"]
    assert_equal expected, p1_grid.valid_targets
  end

  def test_it_can_list_ships_that_are_still_afloat
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A4")
    ship_2 = Ship.new("B3", "C3")

    p1_grid.place_ship(ship_1)
    p1_grid.place_ship(ship_2)

    p1_grid.resolve_shot("B3")
    p1_grid.resolve_shot("C3")

    assert_equal [ship_1], p1_grid.ships_afloat
  end

  def test_returns_gameover_after_last_ship_is_sunk
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("B3", "C3")
    p1_grid.place_ship(ship_1)

    p1_grid.resolve_shot("B3")
    last_shot = p1_grid.resolve_shot("C3")

    assert_equal :gameover, last_shot
  end

  def test_it_can_return_masked_cell_list
    p1_grid = BattleGrid.new(3)
    ship_1 = Ship.new("B3", "C3")
    p1_grid.place_ship(ship_1)
    p1_grid.resolve_shot("B3")
    p1_grid.resolve_shot("A1")

    expected = {"A1" => :miss, "A2" => :water, "A3" => :water,
                "B1" => :water, "B2" => :water, "B3" => :hit,
                "C1" => :water, "C2" =>  :water, "C3" =>  :water}

    assert_equal expected, p1_grid.masked_cells
  end

  def test_it_can_return_a_row
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("B3", "C3")
    p1_grid.place_ship(ship_1)

    expected = [:water, :water, :ship, :water, :water]
    assert_equal expected, p1_grid.row("B")
  end

  def test_it_can_return_all_rows
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("B3", "C3")
    p1_grid.place_ship(ship_1)

    expected = [[:water, :water, :water, :water, :water],
                [:water, :water, :ship, :water, :water],
                [:water, :water, :ship, :water, :water],
                [:water, :water, :water, :water, :water],
                [:water, :water, :water, :water, :water]]

    assert_equal expected, p1_grid.all_rows
  end
end
