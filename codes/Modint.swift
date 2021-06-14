/// ModInt
/// ToDo: 高速化、コンビネーション計算の改善
struct ModInt: AdditiveArithmetic{
    static var zero: ModInt = .init(0)
    var mod: Int
    var value: Int
    init(_ x: Int, _ m: Int = 1_000_000_007){
        mod = m
        value = (x%mod + mod)%mod
    }
    //aの逆元を返す。aとmodは互いに素であることが必要
    func inverse() -> ModInt{
        let a = self
        var x = ModInt(0)
        var y = ModInt(0)
        _ = extendedGCDinModInt(a.value, mod, &x.value, &y.value)
        return x
    }
    func toThePower(of: Int) -> ModInt{
        var p = of
        var res = ModInt(1)
        var x = self
        while(p > 0){
            if((p & 1) == 1){
                res *= x
            }
            x = x * x
            p >>= 1
        }
        return res
    }
    // n choose kを計算する
    //使う前に必ずcreateModIntTablesを呼ぶこと！！
    //n!/k!(n-k)!
    func choose(_ k: Int) -> ModInt{
        assert(modIntTablesCreated, "ModIntTables have not been created, but choose() method in modInt was called")
        let n = self.value
        if(n < k){
            return ModInt(0)
        }
        if(n < 0 || k < 0){
            return ModInt(0)
        }
        return fact[n]*factInv[k]*factInv[n-k]
    }
    //演算子系
    //前置演算子
    prefix static func - (_ x: ModInt) -> ModInt{
        return ModInt(-x.value)
    }
    //複合代入演算子で、Int にModIntを作用させるのも一応定義したけど、あんまり使わない方がいいかも
    //加算
    static func + (left: ModInt, right: ModInt) -> ModInt{
        return ModInt(left.value + right.value)
    }
    static func + (left: Int, right: ModInt) -> ModInt{
        return ModInt(left + right.value)
    }
    static func + (left: ModInt, right: Int) -> ModInt{
        return ModInt(left.value + right)
    }
    static func += (left: inout ModInt, right: ModInt){
        left =  left + right
    }
    static func += (left: inout ModInt, right: Int){
        left =  left + right
    }
 
    static func += (left: inout Int, right: ModInt){
        left = (left + right).value
    }
    //減算
    static func - (left: ModInt, right: ModInt) -> ModInt{
        return ModInt(left.value - right.value)
    }
    static func - (left: Int, right: ModInt) -> ModInt{
        return ModInt(left - right.value)
    }
    static func - (left: ModInt, right: Int) -> ModInt{
        return ModInt(left.value - right)
    }
    static func -= (left: inout ModInt, right: ModInt){
        left = left - right
    }
    static func -= (left: inout ModInt, right: Int){
        left = left - right
    }
    static func -= (left: inout Int, right: ModInt){
        left = (left - right).value
    }
 
    //掛算
    static func * (left: ModInt, right: ModInt) -> ModInt{
        return ModInt(left.value * right.value)
    }
    static func * (left: Int, right: ModInt) -> ModInt{
        return ModInt(left * right.value)
    }
    static func * (left: ModInt, right: Int) -> ModInt{
        return ModInt(left.value * right)
    }
    static func *= (left: inout ModInt, right: ModInt){
        left = left * right
    }
    static func *= (left: inout ModInt, right: Int){
        left = left * right
    }
    static func *= (left: inout Int, right: ModInt){
        left = (left * right).value
    }
 
    //割り算
    static func / (left: ModInt, right: ModInt) -> ModInt{
        return left * right.inverse()
    }
    static func / (left: Int, right: ModInt) -> ModInt{
        return left * right.inverse()
    }
    static func / (left: ModInt, right: Int) -> ModInt{
        return left * ModInt(right).inverse()
    }
    static func /= (left: inout ModInt, right: ModInt){
        left = left / right
    }
    static func /= (left: inout ModInt, right: Int){
        left = left / right
    }
    static func /= (left: inout Int, right: ModInt){
        left = (left * right.inverse()).value
    }
    static func % (left: ModInt, right: ModInt) -> ModInt{
        return ModInt(left.value % right.value)
    }
    static func % (left: ModInt, right: Int) -> ModInt{
        return ModInt(left.value % right)
    }
    static func % (left: Int, right: ModInt) -> ModInt{
        return ModInt(left % right.value)
    }
    static func %= (left: inout ModInt, right: ModInt){
        left = left % right
    }
    static func %= (left: inout ModInt, right: Int){
        left = left % right
    }
    static func %= (left: inout Int, right: ModInt){
        left = (left % right).value
    }
    //等価演算子
    static func == (left: ModInt, right: ModInt) -> Bool{
        return (left.value == right.value)
    }
    static func == (left: ModInt, right: Int) -> Bool{
        return (left.value == right)
    }
    static func == (left: Int, right: ModInt) -> Bool{
        return (left == right.value)
    }
    static func != (left: ModInt, right: ModInt) -> Bool{
        return left.value != right.value
    }
    static func != (left: ModInt, right: Int) -> Bool{
        return left.value != right
    }
    static func != (left: Int, right: ModInt) -> Bool{
        return left != right.value
    }
    static func < (left: ModInt, right: ModInt) -> Bool{
        return left.value < right.value
    }
    static func < (left: ModInt, right: Int) -> Bool{
        return left.value < right
    }
    static func < (left: Int, right: ModInt) -> Bool{
        return left < right.value
    }
    static func <= (left: ModInt, right: ModInt) -> Bool{
        return left.value <= right.value
    }
    static func <= (left: ModInt, right: Int) -> Bool{
        return left.value <= right
    }
    static func <= (left: Int, right: ModInt) -> Bool{
        return left <= right.value
    }
    static func > (left: ModInt, right: ModInt) -> Bool{
        return left.value > right.value
    }
    static func > (left: ModInt, right: Int) -> Bool{
        return left.value > right
    }
    static func > (left: Int, right: ModInt) -> Bool{
        return left > right.value
    }
    static func >= (left: ModInt, right: ModInt) -> Bool{
        return left.value >= right.value
    }
    static func >= (left: ModInt, right: Int) -> Bool{
        return left.value >= right
    }
    static func >= (left: Int, right: ModInt) -> Bool{
        return left >= right.value
    }
    //ビット演算
    //正直いらないかも
    static func << (left: ModInt, right: ModInt) -> ModInt{
        return ModInt(left.value << right.value)
    }
    static func << (left: ModInt, right: Int) -> ModInt{
        return ModInt(left.value << right)
    }
    static func << (left: Int, right: ModInt) -> ModInt{
        return ModInt(left << right.value)
    }
 
    static func <<= (left: inout ModInt, right: ModInt){
        return left = ModInt(left.value << right.value)
    }
    static func <<= (left: inout ModInt, right: Int){
        return left = ModInt(left.value << right)
    }
    static func <<= (left: inout Int, right: ModInt){
        return left = ModInt(left << right.value).value
    }
    static func >> (left: ModInt, right: ModInt) -> ModInt{
        return ModInt(left.value >> right.value)
    }
    static func >> (left: ModInt, right: Int) -> ModInt{
        return ModInt(left.value >> right)
    }
    static func >> (left: Int, right: ModInt) -> ModInt{
        return ModInt(left >> right.value)
    }
 
    static func >>= (left: inout ModInt, right: ModInt){
        return left = ModInt(left.value >> right.value)
    }
    static func >>= (left: inout ModInt, right: Int){
        return left = ModInt(left.value >> right)
    }
    static func >>= (left: inout Int, right: ModInt){
        return left = ModInt(left >> right.value).value
    }
}
//階乗テーブル
var fact: [ModInt] = Array(repeating: ModInt(1), count: 2_200_020)
//階乗の逆元(1/(n!))のテーブル
var factInv: [ModInt] = Array(repeating: ModInt(1), count: 2_200_020)
//整数の逆元テーブル
var integerInv: [ModInt] = Array(repeating: ModInt(1), count: 2_200_020)
//テーブルを作ったかのフラグ
var modIntTablesCreated = false
func createModIntTables(_ size: Int = 2_200_020){
    modIntTablesCreated = true
    for i in 2..<size{
        fact[i] = fact[i-1] * i
        integerInv[i] = ModInt(i).inverse()
        factInv[i] = factInv[i-1] * integerInv[i]
    }
}
//拡張ユークリッドの互除法
//ax + by = gcd(a, b)
//x, yを参照渡しで解を求め、gcg(a, b)を返す
//衝突回避のために名前変更してる
func extendedGCDinModInt(_ a: Int, _ b: Int, _ x: inout Int, _ y: inout Int) -> Int{
    if(b == 0){
        x = 1
        y = 0
        return a
    }
    let q = a/b
    let g = extendedGCDinModInt(b, a - q*b, &x, &y)
    let z = x - q*y
    x = y
    y = z
    return g
}
func gcdInModInt(_ val1: ModInt, _ val2: ModInt) -> ModInt{
    var (a, b) = (val1, val2)
    if(a < b){
        swap(&a, &b)
    }
    if(a % b == 0){
        return b
    }
    return gcdInModInt(b, a%b)
}
func lcmInModInt(_ val1: ModInt, _ val2: ModInt) -> ModInt{
    return val1 / gcdInModInt(val1, val2) * val2
}
extension ModInt: CustomStringConvertible{
    var description: String{
        return self.value.description
    }
}

extension ModInt: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.init(value)
    }

    typealias IntegerLiteralType = Int
}
