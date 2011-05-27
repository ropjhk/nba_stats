namespace 'stake' do
  
  task :graphs_by_draft_position do
    1.upto(10) do |i|
      players = Players.get_players_by_draft(-1,1,i)
      cat_title = "num #{i} overall picks"
      calculate_graph_data_by_year(players, cat_title)
    end
  end
  
  def calculate_graph_data_by_year(players)
    
  end
  
  def calculate_graph_data_by_age
  end
end