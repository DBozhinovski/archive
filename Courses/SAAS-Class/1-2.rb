class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end

#part one
def rps_game_winner(game)
  raise WrongNumberOfPlayersError unless game.length == 2

  regex = /[RPS]{1}/i

  game[0][1] = game[0][1].upcase

  #ugly, but I am a Ruby n00b ;)
  if regex.match(game[0][1]) and game[0][1].length == 1 and regex.match(game[1][1]) and game[1][1].length == 1
    
    #even uglier
    if game[0][1] == game[1][1] 
      return game[0]
    elsif game[0][1] == "R" and game[1][1] == "P"
      return game[1]
    elsif game[0][1] == "R" and game[1][1] == "S" 
      return game[0]
    elsif game[0][1] == "P" and game[1][1] == "S" 
      return game[1]  
    elsif game[0][1] == "P" and game[1][1] == "R" 
      return game[0]
    elsif game[0][1] == "S" and game[1][1] == "P" 
      return game[0]  
    elsif game[0][1] == "S" and game[1][1] == "R" 
      return game[1]
    end    
    
  else
    raise NoSuchStrategyError
  end     

end

#part 2
#not entirely sure what it does, but at least it works :D
def rps_tournament_winner(tournament)

  round = []

  tournament.each do|game|
      
    begin
      round.push(rps_game_winner(game))
    rescue Exception=>e
      round.push(rps_tournament_winner(game))
    end

  end 
  
  if round.length > 1 and not round.kind_of?(String)
    return rps_game_winner(round)
  else 
    return round
  end
 
end  

#print rps_tournament_winner(
#  [ ["Armando", "P"], ["Dave", "S"] ]
#) 

print rps_tournament_winner([
[

[ ["Armando", "P"], ["Dave", "S"] ],
[ ["Richard", "R"], ["Michael", "S"] ],

],
[

[ ["Allen", "S"], ["Omer", "P"] ],
[ ["David E.", "R"], ["Richard X.", "P"] ]

]
])

