class Board:boardProtocol
{
    var fields:[[Int]]
    let possibleFields = ["A7", "D7", "G7", "B6", "D6", "F6", "C5", "D5", "E5", "A4", "B4", "C4",
                            "E4", "F4", "G4", "C3", "D3", "E3", "B2", "D2", "F2", "A1", "D1", "G1"];

    init()
    {
        // creates array 7x7 of 0s
        fields = Array(repeating: Array(repeating: 0, count: 7), count: 7)
    }
    
    // turning a position into array coordinates - A1 is 00 (top left corner)
    func convertStringPosition(position: String) -> [Int]
    {
            let targetField = Array(position)
            
            let baseUnicodeA = UnicodeScalar("A") // the unicode of A
            let unicodeY = UnicodeScalar(String(targetField[0])) // the unicode of the letter
            
            let targetX = Int(String(targetField[1]))! - 1
            let targetY = Int(unicodeY!.value) - Int(baseUnicodeA.value)
            
            return [targetX, targetY]
    }
    
    // turning coordinates into string position 
    func convertIntPosition(position:[Int]) -> String
    {
        let baseUnicodeA = UnicodeScalar("A") // the unicode of A
        
        let letter = String(UnicodeScalar(Int(baseUnicodeA.value) + position[1])!)
        let number = String(position[0] + 1)
    
        return letter+number
    }
    
    // function for placing piece
    func place(player: Int, position: String) -> Bool // player could be 1 or 2
    {
        if(possibleFields.contains(position)) // if the move is possible
        {
            let arrPosition = convertStringPosition(position:position)
            let targetX = arrPosition[0]
            let targetY = arrPosition[1]
            
            if(fields[targetX][targetY] == 0) // if the field is empty
            {
                fields[targetX][targetY] = player // placing the player piece
                return true
            }
            // the field is taken
            else
            {
                print("Error, this field is taken! Please select another one.")
                return false
            }
        }
        // the move is invalid
        else
        {
            print("Error, not a valid move! Please reenter.")
            return false
        }
    }
    
    // checks for mills (dami)
    func millCheck(player: Int, fields: [[Int]]) -> Int
    {
        // Easiest and fastest way is to check the fields manually, because of the board's strange arrangement 
        var sumOfMills:Int = 0
        // checking rows
        if(fields[0][0] == player && fields[0][3] == player && fields[0][6] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[1][1] == player && fields[1][3] == player && fields[1][5] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[2][2] == player && fields[2][3] == player && fields[2][4] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[3][0] == player && fields[3][1] == player && fields[3][2] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[3][4] == player && fields[3][5] == player && fields[3][6] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[6][0] == player && fields[6][3] == player && fields[6][6] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[5][1] == player && fields[5][3] == player && fields[5][5] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[4][2] == player && fields[4][3] == player && fields[4][4] == player) { sumOfMills = sumOfMills + 1 }
        
        // checking columns
        if(fields[0][0] == player && fields[3][0] == player && fields[6][0] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[1][1] == player && fields[3][1] == player && fields[5][1] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[2][2] == player && fields[3][2] == player && fields[4][2] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[0][3] == player && fields[1][3] == player && fields[2][3] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[4][3] == player && fields[5][3] == player && fields[6][3] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[2][4] == player && fields[3][4] == player && fields[4][4] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[1][5] == player && fields[3][5] == player && fields[5][5] == player) { sumOfMills = sumOfMills + 1 }
        if(fields[0][6] == player && fields[3][6] == player && fields[6][6] == player) { sumOfMills = sumOfMills + 1 }
  
        return sumOfMills
    }
    
    // removes player's piece
    func remove(player: Int, position: String) -> Bool
    {	
	if(position.count != 2)
	{
		return false
	}
        let arrPosition = convertStringPosition(position:position)
        let targetX = arrPosition[0]
        let targetY = arrPosition[1]

        
        // if the field contains player's piece
        if(fields[targetX][targetY] == player)
        {
            var changedFields = fields
            changedFields[targetX][targetY] = 0
            
            // check if the removed piece was not part of a mill
            if(millCheck(player: player, fields: fields) == millCheck(player: player, fields: changedFields))
            {
                fields[targetX][targetY] = 0
                return true
            }
            // the piece WAS part of a mill
            else
            {
                // check if all of the player's pieces are in mills
                if(allPiecesInMills(player: player))
                {
                    fields[targetX][targetY] = 0
                    return true
                }
                else
                {
                    print("Error, this enemy piece is part of a mill. Select another one.")
                    return false
                }
            }
        }
        else
        {
            print("Error, no enemy piece on this field! Please reenter.")
            return false
        }
       
    }
    
    // this function is used to determine if all of player's pieces are part of mills
    func allPiecesInMills(player: Int) -> Bool
    {
        for i in 0...23
        {   
            let intPosition = convertStringPosition(position: possibleFields[i])
	    let j = intPosition[0]
	    let k = intPosition[1]
	    if(fields[j][k] == player)
	    {
            	if(!pieceInMill(player: player, position: possibleFields[i], fields: fields))
	    	{
			return false
	    	}
	    }
	}
        return true
    }

    func pieceInMill(player: Int, position: String, fields:[[Int]]) -> Bool
    {	
	if(position.count != 2)
	{
		 return false
	}
	let intPosition = convertStringPosition(position: position)
        let i = intPosition[0]
        let j = intPosition[1]
	var changedFields = fields
	changedFields[i][j] = 0
	if(millCheck(player: player, fields: fields) == millCheck(player: player, fields: changedFields))
	{	
		return false
	}
	return true
	
    }
    
    func move(player: Int, input: String) -> Bool
    {
        let start = String(input.prefix(2))
        let end = String(input.suffix(2))
       
	let nPieces = piecesLeft(player:player)
 
        if(!possibleFields.contains(start) || !possibleFields.contains(end) || start == end)
        {
            print("Error, not a valid move. Select again.")
            return false
        }
        
        let start_coordinates = convertStringPosition(position: start)
        let end_coordinates = convertStringPosition(position: end)
        
        if(fields[start_coordinates[0]][start_coordinates[1]] != player)
        {
            print("Error, wrong starting square. Select again.")
            return false
        }
        
        if(fields[end_coordinates[0]][end_coordinates[1]] != 0)
        {
            print("Error, target square is already taken. Select again.")
            return false
        }
        
        if(start_coordinates[0] != end_coordinates[0] && start_coordinates[1] != end_coordinates[1] && nPieces > 3)
        {
            print("Error, the fields must be adjacent. Select again.")
            return false 
        }
        
	// check if the player can fly
        if(nPieces == 3)
        {
            fields[start_coordinates[0]][start_coordinates[1]] = 0
            fields[end_coordinates[0]][end_coordinates[1]] = player
            return true
        }
        else
	{
            var upperField:[Int]
            var lowerField:[Int]
            var leftField:[Int]
            var rightField:[Int]
            
            if(start_coordinates[0] > end_coordinates[0])
            {
                upperField = end_coordinates
                lowerField = start_coordinates
            }
            else
            {
                upperField = start_coordinates
                lowerField = end_coordinates
            }
            if(start_coordinates[1] > end_coordinates[1])
            {
                leftField = end_coordinates
                rightField = start_coordinates
            }
            else
            {
                leftField = start_coordinates
                rightField = end_coordinates
            }
            // check if they are on the same row
            if(start_coordinates[0] == end_coordinates[0])
            {
                for i in leftField[1]+1..<rightField[1]
                {
                    if(possibleFields.contains(convertIntPosition(position: [start_coordinates[0], i])))
                    {
                        print("Not a valid move, you can't skip fields. Select again.")
                        return false
                    }
                }
                
                fields[start_coordinates[0]][start_coordinates[1]] = 0
                fields[end_coordinates[0]][end_coordinates[1]] = player
                
                return true
            }
            // they are on the same column
            else
            {
                for i in upperField[0]+1..<lowerField[0]
                {
                    if(possibleFields.contains(convertIntPosition(position: [i, start_coordinates[1]])))
                    {
                        print("Not a valid move, you can't skip fields. Select again.")
                        return false
                    }
                }
                
                fields[start_coordinates[0]][start_coordinates[1]] = 0
                fields[end_coordinates[0]][end_coordinates[1]] = player
                return true
            }
	}
    }

    func piecesLeft(player:Int) ->Int
    {	
	var nPieces = 0
	for i in 0...6
	{
		for j in 0...6
		{
			if(fields[i][j] == player)
			{
				nPieces = nPieces + 1
			}
		}
	}
	return nPieces
    }
    // prints the Board
    func printBoard()
    {
        var boardPieces = Array(repeating: Array(repeating: "·", count: 7), count: 7)

        // converting player numbers to pieces
        for i in 0...6
        {
            for j in 0...6
            {
                if(fields[i][j] == 1) { boardPieces[i][j] = "○"}
                else if(fields[i][j] == 2){boardPieces[i][j] = "●"}
            }
        }

        for _ in 0...30
        {
                print()
        }

	print("     A   B   C   D   E   F   G")
        print("   1 ", terminator: "")
        print(boardPieces[0][0], terminator: "")
        print("-----------", terminator: "")
        print(boardPieces[0][3], terminator: "")
        print("-----------", terminator: "")
        print(boardPieces[0][6], terminator: "\n")


        print("     |           |           |", terminator: "\n")

        print("   2 |   ", terminator: "")
        print(boardPieces[1][1], terminator: "")
        print("-------", terminator: "")
        print(boardPieces[1][3], terminator: "")
        print("-------", terminator: "")
        print(boardPieces[1][5], terminator: "")
        print("   |", terminator: "\n")

        print("     |   |       |       |   |", terminator: "\n")

        print("   3 |   |   ", terminator: "")
        print(boardPieces[2][2], terminator: "")
        print("---", terminator: "")
        print(boardPieces[2][3], terminator: "")
        print("---", terminator: "")
        print(boardPieces[2][4], terminator: "")
        print("   |   |", terminator: "\n")


        print("     |   |   |       |   |   |", terminator: "\n")
	
	print("   4 ", terminator: "")
        print(boardPieces[3][0], terminator: "")
        print("---", terminator: "")
        print(boardPieces[3][1], terminator: "")
        print("---", terminator: "")
        print(boardPieces[3][2], terminator: "")
        print("       ", terminator: "")
        print(boardPieces[3][4], terminator: "")
        print("---", terminator: "")
        print(boardPieces[3][5], terminator: "")
        print("---", terminator: "")
        print(boardPieces[3][6], terminator: "\n")

        print("     |   |   |       |   |   |", terminator: "\n")

        print("   5 |   |   ", terminator: "")
        print(boardPieces[4][2], terminator: "")
        print("---", terminator: "")
        print(boardPieces[4][3], terminator: "")
        print("---", terminator: "")
        print(boardPieces[4][4], terminator: "")
        print("   |   |", terminator: "\n")

        print("     |   |       |       |   |", terminator: "\n")

        print("   6 |   ", terminator: "")
        print(boardPieces[5][1], terminator: "")
        print("-------", terminator: "")
        print(boardPieces[5][3], terminator: "")
        print("-------", terminator: "")
        print(boardPieces[5][5], terminator: "")
        print("   |", terminator: "\n")

        print("     |           |           |", terminator: "\n")

	print("   7 ", terminator: "")
	print(boardPieces[6][0], terminator: "")
	print("-----------", terminator: "")
        print(boardPieces[6][3], terminator: "")
        print("-----------", terminator: "")
        print(boardPieces[6][6], terminator: "\n")

        for _ in 0...5
        {
		print()
	}    
    }	
}
