/// Matrix
/// 初期化は(行数, 列数)を渡すのが基本。それ以外は実装を読んで確認。
/// M.dot(L)で(アダマール積ではない)積
/// ElementをIntにした場合はM.modPow(p, mod)が可能。
protocol Field: Numeric {
    static var multiplicationIdentity: Self {get}
    static prefix func - (value: Self) -> Self
    static func / (lhs: Self, rhs: Self) -> Self
}
extension Int: Field { //違うけど仕方ない。
    static var multiplicationIdentity: Int = 1
}
extension Double: Field { //厳密には違うけど仕方ない。
    static var multiplicationIdentity: Double = 1.0
}

struct Matrix<Element: Field>{
    var elements: [Element]
    var shape: (Int, Int)
    init(_ shape: (Int, Int)){
        self.shape = shape
        elements = Array(repeating: Element.zero, count: shape.0*shape.1)
    }
    init(_ row: Int, _ column: Int){
        self.init((row, column))
    }
    init(_ x: [[Element]]){
        elements = Array(x.joined())
        shape = (x.count, x[0].count)
    }
    init(_ x: [Element], _ shape: (Int, Int)){
        self.shape = shape
        self.elements = x
    }
    //defaultは縦
    init(_ x: [Element], _ horizontal: Bool = false){
        elements = x
        shape = horizontal ? (1, x.count) : (x.count, 1)
    }
    init(identity size: Int){
        elements = Array(repeating: Element.zero, count: size*size)
        shape = (size, size)
        for i in 0..<size{
            elements[i + size*i] = Element.multiplicationIdentity
        }
    }
    subscript(_ i: Int, _ j: Int) -> Element{
        get{
            assert(i < shape.0 && j < shape.1, "Index out of range")
            return elements[shape.1 * i + j]
        }
        set{
            assert(i < shape.0 && j < shape.1, "Index out of range")
            elements[shape.1*i + j] = newValue
        }
    }
    subscript(_ index: Int) -> [Element]{
        get{
            assert(index < shape.0, "Index out of range")
            return Array(elements[shape.1*(index)..<(index+1)*shape.1])
        }
    }
    var T: Matrix{
        return Matrix(elements, (shape.1, shape.0))
    }
    func dot(_ value: Matrix) -> Matrix{
        assert(self.shape.1 == value.shape.0, "Shape error")
        var res: Matrix = Matrix(self.shape.0, value.shape.1)
        for i in 0..<self.shape.0{
            for j in 0..<value.shape.1{
                for k in 0..<self.shape.1{
                    res[i, j] += self[i, k] * value[k, j]
                }
            }
        }
        return res
    }
    func pow(_ p: Int) -> Matrix{
        var p = p
        var x = self
        var res = Matrix(self.shape)
        for i in 0..<min(res.shape.0, res.shape.1){
            res[i, i] = Element.multiplicationIdentity
        }
        while(p > 0){
            if((p&1) == 1){
                res = res.dot(x)
            }
            x = x.dot(x)
            p >>= 1
        }
        return res
    }
    static prefix func - (_ matrix: Matrix) -> Matrix{
        return Matrix(matrix.elements.map{-$0}, matrix.shape)
    }
    static func + (_ left: Matrix, _ right: Matrix) -> Matrix{
        assert(left.shape == right.shape, "Shapes must be same")
        var res: [Element] = []
        for idx in 0..<left.elements.count{
            res.append(left.elements[idx] + right.elements[idx])
        }
        return Matrix(res, left.shape)
    }
    static func - (_ left: Matrix, _ right: Matrix) -> Matrix{
        return left + (-right)
    }
    static func * (_ left: Matrix, _ right: Matrix) -> Matrix{
        var res: [Element] = []
        for idx in 0..<left.elements.count{
            res.append(left.elements[idx] * right.elements[idx])
        }
        return Matrix(res, left.shape)
    }
    static func += (_ left: inout Matrix, _ right: Matrix){
        left = left + right
    }
    static func -= (_ left: inout Matrix, _ right: Matrix){
        left = left - right
    }
    static func *= (_ left: inout Matrix, _ right: Matrix){
        left = left * right
    }
    static func * (_ left: Element, _ right: Matrix) -> Matrix{
        return Matrix(right.elements.map{left*$0}, right.shape)
    }
    static func * (_ left: Matrix, _ right: Element) -> Matrix{
        return right*left
    }
    static func *= (_ left: inout Matrix, _ right: Element){
        left = right * left
    } 
    static func / (_ left: Matrix, _ right: Element) -> Matrix{
        return Matrix(left.elements.map {$0/right}, left.shape)
    }
    static func /= (_ left: inout Matrix, _ right: Element){
        left = left / right
    }
}
extension Matrix: CustomStringConvertible{
    var description: String{
        var res: String = "["
        for i in 0..<(shape.0-1){
            res += self[i].description
            res += "\n "
        }
        return res + self[shape.0-1].description + "]"
    }
}
extension Matrix where Element == Int{
    func modDot(_ value: Matrix<Int>, _ Mod: Int) -> Matrix<Int>{
        assert(self.shape.1 == value.shape.0, "Shape error")
        var res: Matrix<Int> = Matrix<Int>(self.shape.0, value.shape.1)
        for i in 0..<self.shape.0{
            for j in 0..<value.shape.1{
                for k in 0..<self.shape.1{
                    res[i, j] = (res[i, j] + self[i, k] * value[k, j]) % Mod
                }
            }
        }
        return res
    }
    func modPow(_ p: Int,_ mod: Int) -> Matrix<Int>{
        var p = p
        var x = self
        var res = Matrix<Int>(self.shape)
        for i in 0..<min(res.shape.0, res.shape.1){
            res[i, i] = 1
        }
        while(p > 0){
            if((p&1) == 1){
                res = modDot(x, mod)
            }
            x = modDot(x, mod)
            p >>= 1
        }
        return res
    }
}
