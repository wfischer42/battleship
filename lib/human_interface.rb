require_relative './player_interface'

class HumanInterface < PlayerInterface

  def refresh(message)
    clear_screen
    display_gameboard
    puts message + "\n\n"
  end

  def clear_screen
    print %x{clear}
    puts " BATTLESHIP: Terminal Edition\n\n"
  end

  def announce_commencement
    message = "It's time for an EPIC battle between ASCII battleships! Beware: I am a computer, and computers never lose. For example, HAL beat Dave, Deep Blue beat Gary Kasparov, and I will most certainly beat you! BWAHAHAHAHAHAHAHAHA.\n\nNow, place your ships by entering the starting and ending spaces where you want them..."

    refresh(message)
  end

  def announce_first_player(player)
    message = "#{player.capitalize} will be going first!"
    refresh(message)
    sleep 2 if player == :computer
    # sleep 0.5
  end

  def announce_resolution(player, res)
    message = missed_res(player, res) if res[1] == :miss
    message = hit_res(player, res) if res[1] == :hit
    message = sunk_res(player, res) if res[1] == :sunk
    message = "" if res[1] == :gameover

    refresh(message)
    sleep 2 if player == :human
    # sleep 0.5
  end

  def missed_res(player, res)
      "#{player.capitalize} aimed at #{res[0]} and MISSED!"
  end

  def hit_res(player, res)
    "#{player.capitalize} hit #{res[0]}!"
  end

  def sunk_res(player, res)
    "#{player.capitalize} fired at #{res[0]} sunk a #{res[2]} unit ship!"
  end

  def announce_conclusion(winner, turns)
    message = "The #{winner.to_s} won after #{turns} shots!"
    refresh(message)
  end

  def display_gameboard
    display_opponent_board
    display_player_board
  end

  def display_opponent_board
    grouped = @opponent_board.group_by do |cell, value|
      cell[0]
    end
    puts "      COOL COMPUTER"
    puts "     1    2    3    4"
    print "   ---------------------\n"

    grouped.each do |letter, row|
      print " #{letter} |"
      display_row(row)
      print "\n   ---------------------\n"
    end
    print "   |||||||||||||||||||||\n"
  end

  def display_player_board
    grouped = @player_board.group_by do |cell, value|
      cell[0]
    end
    print "   ---------------------\n"

    grouped.each do |letter, row|
      print " #{letter} |"
      display_row(row)
      print "\n   ---------------------\n"
    end
    puts "     1    2    3    4\n"
    puts "      FOOLISH HUMAN\n\n"

  end

  def display_row(row)
    row.each do |cell|
      display_cell(cell[1])
    end
  end

  def display_cell(cell)

    h = "\u{1F4A5}"	# explosion
    m = "\u{1F4A6}" # splash
    w = "\u{1F30A}"	# wave
    s = "\u{1F6A4}"	# boat
    u = "\u{2620} "	# skull & crossbones

    print " #{w} |" if cell == :water
    print " #{s} |" if cell == :ship
    print " #{h} |" if cell == :hit
    print " #{m} |" if cell == :miss
    print " #{u} |" if cell == :sunk
  end
end
