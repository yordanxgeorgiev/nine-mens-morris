class GameLogic
{
    var board = Board()
    
    func phasePlacingPieces()
    {
        board.printBoard()
        
        // for 9 turns players place pieces
        for _ in 0...8
        {   
            for j in 1...2
            {   
                // choosing field to place piece and checking for mills
                let playerMills1 = board.millCheck(player:j, fields: board.fields)
                var input = ""
                print("Player \(j), choose position to place piece: ", terminator: "")
                input = readLine()!
                while(!board.place(player:j, position: input))
                {
                    print("New choice: " , terminator: "")
                    input = readLine()!
                }
                
                var playerMills2 = board.millCheck(player:j, fields: board.fields)
                board.printBoard()
 
                // The player has made a mill
                while(playerMills2 > playerMills1)
                {
		    var enemy:Int
		    if(j == 1)
		    {
			enemy = 2
		    }
		    else
		    {
			enemy = 1
	            }
                    print("Mill! Player \(j), choose an enemy piece to remove: " , terminator: "")
                    input = readLine()!
                    while(!board.remove(player:enemy, position: input))
                    {
                        print("New choice: " , terminator: "")
                        input = readLine()!
                    }
                    playerMills2 = playerMills2 - 1
		    board.printBoard()
                }
            } 
        }
        
    }
    func phaseMovingPieces()
    {
   	while(true)
	{
		for i in 1...2
		{	
			let fieldsBeforeChange = board.fields
			// making a move
			let playerMills1 = board.millCheck(player: i, fields: board.fields)
			var input = ""
			print("Player \(i), select a move (ex. A1A4): ")
			input = readLine()!
			while(!board.move(player: i, input: input))
			{
				print("New choice: ")
				input = readLine()!
			}
			var playerMills2 = board.millCheck(player: i, fields: board.fields)
			board.printBoard()
			
			let startingPosition = String(input.prefix(2))

			var enemy:Int
                        if(i == 1)
                        {
                        	enemy = 2
                        }
                        else
                        {
                        	enemy = 1
                        }
			// checking for new mill
			if(playerMills2 > playerMills1 || (playerMills2 == playerMills1 && (board.pieceInMill(player: i, position:startingPosition, fields: fieldsBeforeChange))))
                    	{
				print("Mill! Player \(i), choose an enemy piece to remove: " , terminator: "")
                    		input = readLine()!
                    		while(!board.remove(player:enemy, position: input))
                    		{
                        	print("New choice: " , terminator: "")
                        	input = readLine()!
                    		}
                    		playerMills2 = playerMills2 - 1
                    		board.printBoard()
			}
			if(board.piecesLeft(player: enemy) < 3)
			{
				print("Player \(i) wins!!!")
				return
			}
		}
	}
    }
    
    func startGame()
    {
        phasePlacingPieces()
	if(board.piecesLeft(player:1) < 3)
	{
		print("Player 2 wins!!!")
		return
	}	
	if(board.piecesLeft(player:2) < 3)
	{
		print("Player 1 wins!!!")
		return
	}

	phaseMovingPieces()
    }
}
