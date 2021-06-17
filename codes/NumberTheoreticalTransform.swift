/// NTT
/// FFTを適当にいじっただけ
/// verify: ATC001-C 高速フーリエ変換, 典型90問-065 RGB Balls 2
/// 単体で使う時は
/// var ntt = NTT()
/// ntt.numberTheoreticalTransform(&function: [ModInt], _ inverse: Bool)
extension ModInt {
    //p = 2^m * a + 1の時、primitiveRoot = gとしてフェルマーの小定理から、
    //g ^(2^m * a) = (g^a) ^ (2^m) ≡ 1 (mod p)
    //degree = m, maxroot = g^aとして定義する。
    //aをmodPowの第二引数に渡す。

    //mod = 998244353
    static var primitiveRoot: Self = 3
    static var degree: Int = 23
    static var maxRoot: ModInt = 15311432 //3^119

    /*
    次数が大きい時用。mod指定がない場合はmodを超えた際に落ちるので注意。未verify。

    //mod = 1224736769
    static var primitiveRoot: Self = 3
    static var degree: Int = 24
    static var maxRoot: ModInt = 1098543633 //3^73

    //mod = 167772161
    static var primitiveRoot: Self = 3
    static var degree: Int = 25
    static var maxRoot: ModInt = 243 //3^5

    //mod = 469762049
    static var primitiveRoot: Self = 3
    static var degree: Int = 26
    static var maxRoot: ModInt = 2187 //3^7
    */
}
struct NTT {
    var root: [ModInt] = Array(repeating: ModInt.maxRoot, count: ModInt.degree+1)
    var rootInverse: [ModInt] = Array(repeating: 1/ModInt.maxRoot, count: ModInt.degree+1)
    init() {
        for i in (0..<ModInt.degree).reversed() {
            root[i] = root[i+1] * root[i+1]
            rootInverse[i] = rootInverse[i+1] * rootInverse[i+1]
        }
    }
    private func bitReverse(_ x: Int, _ k: Int) -> Int{
        var res = 0
        for i in 0..<k{
            res |= (x >> i & 1) << (k - 1 - i)
        }
        return res
    }
    func numberTheoreticalTransform(_ function:[ModInt], _ inverse: Bool = false) -> [ModInt]{
        let size = function.count
        var function = function
        var k = 0
        while((1 << k) < size){
            k += 1
        }
        for i in 0..<size{
            let j = bitReverse(i, k)
            if(i < j){
                function.swapAt(i, j)
            }
        }
        var operationSize = 1
        var cnt = 1
        while(operationSize < size){
            let zeta: ModInt = inverse ? root[cnt] : rootInverse[cnt]
            cnt += 1
            var omega: ModInt = 1
            for i in 0..<operationSize{
                var j = 0
                while(j < size){
                    let s = function[i + j], t = function[i + j + operationSize] * omega
                    function[i + j] = s + t
                    function[i + j + operationSize] = s - t
                    j += 2 * operationSize
                }
                omega *= zeta
            }
            operationSize *= 2
        }
        if(inverse){
            function = function.map {$0 / ModInt(size)}
        }
        return function
    }
}

