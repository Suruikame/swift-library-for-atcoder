///二次元行列
/// ToDo: genericsへの対応
class Matrix{
    var elements: [Int] = []
    var shape: (Int, Int)
    init(_ shape: (Int, Int)){
        self.shape = shape
        elements = Array(repeating: 0, count: shape.0*shape.1)
    }
    init(_ row: Int, _ column: Int){
        self.shape = (row, column)
        elements = Array(repeating: 0, count: row * column)
    }
    init(_ x: [[Int]]){
        for arr in x{
            elements += arr
        }
        shape = (x.count, x[0].count)
    }
    init(_ x: [Int], _ shape: (Int, Int)){
        self.shape = shape
        self.elements = x
    }
    subscript(_ index: (Int, Int)) -> Int{
        get{
            assert(index.0 < shape.0 && index.1 < shape.1, "Index out of range")
            return elements[shape.0 * index.0 + index.1]
        }
        set{
            assert(index.0 < shape.0 && index.1 < shape.1, "Index out of range")
            elements[shape.0*index.0 + index.1] = newValue
        }
    }
    subscript(_ index: Int) -> [Int]{
        get{
            assert(index < shape.0, "Index out of range")
            return Array(elements[shape.0*(index)..<(index+1)*shape.0])
        }
    }
    var description: String{
        var res: String = "["
        for i in 0..<(shape.0-1){
            res += self[i].description
            res += "\n "
        }
        return res + self[shape.0-1].description + "]"
    }
    func dot(_ left: Matrix, _ right: Matrix) -> Matrix{
        assert(left.shape.1 == right.shape.0, "Shape error")
        var res: [[Int]] = Array(repeating: Array(repeating: 0, count: right.shape.1), count: left.shape.0)
        for i in 0..<left.shape.0{
            for j in 0..<right.shape.1{
                for k in 0..<left.shape.1{
                    res[i][j] += left[i][k] * right[k][j]
                }
            }
        }
        return Matrix(res)
    }
    func modDot(_ left: Matrix, _ right: Matrix, _ mod: Int) -> Matrix{
        assert(left.shape.1 == right.shape.0, "Shape error")
        var res: [[Int]] = Array(repeating: Array(repeating: 0, count: right.shape.1), count: left.shape.0)
        for i in 0..<left.shape.0{
            for j in 0..<right.shape.1{
                for k in 0..<left.shape.1{
                    res[i][j] = (left[i][k] * right[k][j] + res[i][j])%mod
                }
            }
        }
        return Matrix(res)
    }
    func pow(_ value: Matrix, _ pIn: Int) -> Matrix{
        var p = pIn
        var x = value
        var res = Matrix(value.shape)
        for i in 0..<min(res.shape.0, res.shape.1){
            res[(i, i)] = 1
        }
        while(p > 0){
            if((p&1) == 1){
                res = dot(res, x)
            }
            x = dot(x, x)
            p >>= 1
        }
        return res
    }
    func modPow(_ value: Matrix, _ pIn: Int,_ mod: Int) -> Matrix{
        var p = pIn
        var x = value
        var res = Matrix(value.shape)
        for i in 0..<min(res.shape.0, res.shape.1){
            res[(i, i)] = 1
        }
        while(p > 0){
            if((p&1) == 1){
                res = modDot(res, x, mod)
            }
            x = modDot(x, x, mod)
            p >>= 1
        }
        return res
    }
    static prefix func - (_ matrix: Matrix) -> Matrix{
        return Matrix(matrix.elements.map{-$0}, matrix.shape)
    }
    static func + (_ left: Matrix, _ right: Matrix) -> Matrix{
        assert(left.shape == right.shape, "Shapes must be same")
        var res: [Int] = []
        for idx in 0..<left.elements.count{
            res.append(left.elements[idx] + right.elements[idx])
        }
        return Matrix(res, left.shape)
    }
    static func - (_ left: Matrix, _ right: Matrix) -> Matrix{
        return left + (-right)
    }
    static func * (_ left: Matrix, _ right: Matrix) -> Matrix{
        var res: [Int] = []
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
    static func * (_ left: Int, _ right: Matrix) -> Matrix{
        return Matrix(right.elements.map{left*$0}, right.shape)
    }
    static func * (_ left: Matrix, _ right: Int) -> Matrix{
        return right*left
    }
    static func *= (_ left: inout Matrix, _ right: Int){
        left = right * left
    }
    
}