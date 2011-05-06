namespace 'stake' do
  task :asdf do
    playoff_games = Game.find_by_game_type("playoff")
    
    playoff_games.each do |pg|
      
    end
    
  end
end