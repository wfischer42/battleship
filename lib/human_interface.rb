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
  end

  def announce_resolution(player, resolution)
    message =  "#{player.capitalize} aimed at #{resolution[0]}: #{resolution[1].to_s}!"

    refresh(message)
    sleep 2 if player == :human
  end

  def announce_conclusion(winner, turns)
    message = "The #{winner.to_s} won after #{turns} shots!"
    refresh(message)
  end

  def get_placement(ship_size)
    print "Place Ship (size #{ship_size}) > "
    loop do
      input = gets.chomp.upcase
      exit if input[0] == "Q"
      return input.split if valid_placement?(input.split, ship_size)
      print "You can't put that ship there! Try again > "
    end
  end

  def take_turn
    print "Human: It's your turn! Take aim! > "
    loop do
      input = gets.chomp.upcase
      exit if input[0] == "Q"
      return input if valid_target?(input)
      print "#{input} is not a valid target! Try again > "
    end
  end

  def display_gameboard
    display_opponent_board
    display_player_board
  end

  def display_opponent_board
    grouped = @opponent_board.group_by do |cell, value|
      cell[0]
    end
    puts "     COOL COMPUTER"
    puts "     1   2   3   4"
    print "   -----------------\n"

    grouped.each do |letter, row|
      print " #{letter} |"
      display_row(row)
      print "\n   -----------------\n"
    end
    print "   |||||||||||||||||\n"
  end

  def display_player_board
    grouped = @player_board.group_by do |cell, value|
      cell[0]
    end
    print "   -----------------\n"

    grouped.each do |letter, row|
      print " #{letter} |"
      display_row(row)
      print "\n   -----------------\n"
    end
    puts "     1   2   3   4\n"
    puts "     FOOLISH HUMAN\n\n"

  end

  def display_row(row)
    row.each do |cell|
      display_cell(cell[1])
    end
  end

  def display_cell(cell)
    print " ~ |" if cell == :water
    print " S |" if cell == :ship
    print " H |" if cell == :hit
    print " M |" if cell == :miss
  end
end
