# spec/tictactoe_spec.rb
require_relative '../lib/tictactoe'

describe Tictactoe do
  subject(:my_game) { described_class.new }

  describe '#names' do
    context 'It outputs correct names' do
      it 'Outputs Marks and kenny' do
        allow(my_game).to receive(:gets).and_return('Mark', 'kenny')
        allow(my_game).to receive(:puts)
        message = 'The names are Mark and kenny'
        expect(my_game).to receive(:puts).with(message).once
        my_game.names
      end
    end
  end

  describe '#make_board' do
    # no testing needed
  end

  describe '#display_board' do
    context 'It displays the board correctly' do
      before do
        allow(my_game).to receive(:puts)
        my_game.make_board
      end
      it 'Displays 3 rows' do
        expect(my_game).to receive(:puts).with(a_string_including('|')).thrice
        my_game.display_board
      end

      it 'Only puts the row seperator twice' do
        row_sep = '--+---+--'
        expect(my_game).to receive(:puts).with(row_sep).twice
        my_game.display_board
      end
    end
  end

  describe '#get_choice' do
    before do
      allow(my_game).to receive(:puts)
    end
    context 'It asks for the correct choice from the correct player' do
      before do
        allow(my_game).to receive(:gets).and_return('6')
        my_game.player_1 = 'Jack'
        my_game.player_2 = 'Lily'
      end

      it "When the id is 'O'" do
        my_game.id = 'O'
        expect(my_game).to receive(:puts).with('Player Jack, Please enter the box number to mark').once
        my_game.get_choice
      end

      it "When the id is 'X'" do
        my_game.id = 'X'
        expect(my_game).to receive(:puts).with('Player Lily, Please enter the box number to mark').once
        my_game.get_choice
      end
    end
    context 'It takes the correct input and breaks' do
      before do
        my_game.instance_variable_set('@log', [1, 2, 3])
      end

      it 'When the player inputs a valid number' do
        error_message = 'You have entered an invalid number, please try again'
        allow(my_game).to receive(:gets).and_return('5')
        expect(my_game).to_not receive(:puts).with(error_message)
        my_game.get_choice
      end

      it 'When the player enters two invalid numbers then valid' do
        error_message = 'You have entered an invalid number, please try again'
        allow(my_game).to receive(:gets).and_return('100', '50', '6')
        expect(my_game).to receive(:puts).with(error_message).twice
        my_game.get_choice
      end

      it 'When user enters valid input that is present in log' do
        error_message = 'You have entered an invalid number, please try again'
        allow(my_game).to receive(:gets).and_return('3', '6')
        expect(my_game).to receive(:puts).with(error_message).once
        my_game.get_choice
      end
    end

    context 'It sends a message to update ID' do
      before do
        allow(my_game).to receive(:update_id)
        allow(my_game).to receive(:loop).and_yield
      end

      it 'When the input is correct' do
        allow(my_game).to receive(:gets).and_return('5')
        expect(my_game).to receive(:update_id).once
        my_game.get_choice
      end

      it 'When the input is incorrect' do
        allow(my_game).to receive(:gets).and_return('100')
        expect(my_game).to_not receive(:update_id)
        my_game.get_choice
      end
    end
  end

  describe '#update_id' do
    context 'It updates the id correctly' do
      it 'When the id is X' do
        my_game.instance_variable_set('@id', 'X')
        expect { my_game.update_id }.to change { my_game.id }.to('O')
      end

      it 'When the id is O' do
        my_game.instance_variable_set('@id', 'O')
        expect { my_game.update_id }.to change { my_game.id }.to('X')
      end
    end
  end

  describe '#mark_board' do
    before do
      my_game.make_board
    end
    context 'It marks the board correctly' do
      it 'When player marks X at box 3' do
        my_game.instance_variable_set('@id', 'X')
        my_game.instance_variable_set('@selection', 3)
        expect { my_game.mark_board }.to change { my_game.board }.to([[1, 2, 'X'], [4, 5, 6], [7, 8, 9]])
      end

      it 'When player marks O at box 8' do
        my_game.instance_variable_set('@id', 'O')
        my_game.instance_variable_set('@selection', 8)
        expect { my_game.mark_board }.to change { my_game.board }.to([[1, 2, 3], [4, 5, 6], [7, 'O', 9]])
      end
    end

    context 'It updates the log' do
      it 'updates the log by 1' do
        my_game.instance_variable_set('@selection', 8)
        expect { my_game.mark_board }.to change { my_game.log.length }.by(1)
      end
    end
  end

  describe '#check_win' do
    context 'It checks the combinations correctly' do
      it 'Returns false when there is no combination' do
        my_game.board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        expect(my_game.check_win).to be_falsy
      end

      it 'Checks for rows' do
        my_game.board = [[1, 2, 3], %w[X X X], [7, 8, 9]]
        expect(my_game.check_win).to be_truthy
      end

      it 'Checks for columns' do
        my_game.board = [['O', 2, 3], ['O', 5, 6], ['O', 8, 9]]
        expect(my_game.check_win).to be_truthy
      end

      it 'Checks for leading diagonal' do
        my_game.board = [['X', 2, 3], [4, 'X', 6], [7, 8, 'X']]
        expect(my_game.check_win).to be_truthy
      end

      it 'Checks for cross diagonal' do
        my_game.board = [[1, 2, 'O'], [4, 'O', 6], ['O', 8, 9]]
        expect(my_game.check_win).to be_truthy
      end
    end
  end

  describe '#check_draw?' do
    context 'It checks for draw' do
      it 'When the turns are not 9' do
        described_class.class_variable_set(:@@turns, 5)
        expect(my_game.check_draw?).to be_falsy
      end

      it 'When the turns are 9' do
        described_class.class_variable_set(:@@turns, 9)
        expect(my_game.check_draw?).to be_truthy
      end
    end
  end

  describe '#check_winner' do
    context 'It outputs the correct winner' do
      before do
        my_game.player_1 = 'player 1'
        my_game.player_2 = 'player 2'
      end

      it 'When the id is O' do
        my_game.id = 'O'
        expect(my_game).to receive(:puts).with('Congrats! player 2 has won!').once
        my_game.check_winner
      end

      it 'When the id is X' do
        my_game.id = 'X'
        expect(my_game).to receive(:puts).with('Congrats! player 1 has won!').once
        my_game.check_winner
      end
    end
  end
end
