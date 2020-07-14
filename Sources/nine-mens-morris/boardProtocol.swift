protocol boardProtocol
{
    // main functions: placing, moving or removing player's piece
    func place(player: Int, position:String) -> Bool
    func move(player: Int, input: String) -> Bool
    func remove(player: Int, position: String) -> Bool
    
    // ----------------------------------------------------------
    // helping functions 
    
    // checks if a piece is in Mill
    func pieceInMill(player: Int, position: String, fields:[[Int]]) -> Bool
    
    // counts how many mills the player has (used to see if new mills are formed)
    func millCheck(player: Int, fields: [[Int]]) -> Int
    
    // converts string position to int coordinates (ex. A1 is 00)
    func convertStringPosition(position: String) -> [Int]
    
    // converts int coordinates to string position (ex. [0,0] is A1)
    func convertIntPosition(position:[Int]) -> String
    
    // checks if all of player's pieces are in mills (used when removing a piece)
    func allPiecesInMills(player: Int) -> Bool
    
    // returns the number of player pieces
    func piecesLeft(player: Int) -> Int
	
    // prints the board
    func printBoard()
}
