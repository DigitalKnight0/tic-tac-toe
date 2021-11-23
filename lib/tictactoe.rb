# lib/tictactoe.rb

class Tictactoe
  @@turns = 0
  attr_accessor :player_1, :player_2, :board, :id
  attr_reader :log, :selection

  def initialize
    @player_1 = ''
    @player_2 = ''
    @board = Array.new(3)
    @id = 'O'
    @log = []
  end

  def play
    names
    sleep 3
    system('clear')
    make_board

    loop do
      display_board
      get_choice
      mark_board
      sleep 0.5
      system('clear')

      if check_win
        check_winner
        break
      elsif check_draw?
        puts "It's a draw!"
        break
      end
    end
  end

  def names
    puts 'Please Enter Player 1 Name'
    @player_1 = gets.chomp
    puts 'Please Enter Player 2 Name'
    @player_2 = gets.chomp
    puts "The names are #{player_1} and #{player_2}"
    puts 'The Game will start in 3 seconds! Get ready!'
  end

  def make_board
    @board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end

  def display_board
    row_sep = '--+---+--'
    (0..2).each do |i|
      puts board[i].join(' | ')
      puts row_sep if i < 2
    end
  end

  def get_choice
    loop do
      if id == 'O'
        puts "Player #{player_1}, Please enter the box number to mark"
        @selection = gets.chomp.to_i

      else
        puts "Player #{player_2}, Please enter the box number to mark"
        @selection = gets.chomp.to_i

      end

      if !selection.between?(1, 9) || log.any?(selection)
        puts 'You have entered an invalid number, please try again'
      else
        update_id
        break
      end
    end
  end

  def update_id
    @id = id == 'O' ? 'X' : 'O'
  end

  def mark_board
    board.each do |a|
      a[a.index(selection)] = id if a.include?(selection)
    end
    log.push(selection)
  end

  def check_win
    board.each do |i|
      return true if i.all?('X') || i.all?('O')
    end
    board.transpose.each do |i|
      return true if i.all?('X') || i.all?('O')
    end
    if ((0..2).collect { |a| board[a][a] }).all?('O')

      return true
    elsif ((0..2).collect { |a| board[a][a] }).all?('X')

      return true
    elsif ((0..2).collect { |a| board.reverse.transpose[a][a] }).all?('O')

      return true
    elsif ((0..2).collect { |a| board.reverse.transpose[a][a] }).all?('X')
      return true
    end

    false
  end

  def check_draw?
    @@turns == 9
  end

  def check_winner
    if id == 'O'
      puts "Congrats! #{player_2} has won!"
    else
      puts "Congrats! #{player_1} has won!"
    end
  end
end

 myGame = Tictactoe.new
 myGame.play
