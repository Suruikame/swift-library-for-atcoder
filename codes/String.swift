///Character ⇄ Int
extension String{
    var code: Int{
        //文字コードで返す
        //Aが65, aが97, 0が48
        return Int(self.unicodeScalars.first!.value)
    }
}
extension Character{
    var code: Int{
        //文字コードで返す
        //Aが65, aが97, 0が48
        return Int(self.unicodeScalars.first!.value)
        
    }
    init(_ code: Int) {
        self.init(UnicodeScalar(code)!)
    }
    static func < (_ left: Character, _ right: Character) -> Bool{
        return left.code < right.code
    }
    static func <= (_ left: Character, _ right: Character) -> Bool{
        return left.code <= right.code
    }
    static func > (_ left: Character, _ right: Character) -> Bool{
        return left.code > right.code
    }
    static func >= (_ left: Character, _ right: Character) -> Bool{
        return left.code >= right.code
    }
    static func == (_ left: Character, _ right: Character) -> Bool{
        return left.code == right.code
    }
    static func + (lhs: Character, rhs: Int) -> Int {
        return lhs.code + rhs
    }
    static func - (lhs: Character, rhs: Int) -> Int {
        return lhs.code - rhs
    }
    static func + (lhs: Character, rhs: Character) -> Int {
        return lhs.code + rhs.code
    }
    static func - (lhs: Character, rhs: Character) -> Int {
        return lhs.code - rhs.code
    }
    static func + (lhs: Int, rhs: Character) -> Int {
        return lhs + rhs.code
    }
    static func - (lhs: Int, rhs: Character) -> Int {
        return lhs - rhs.code
    }
}