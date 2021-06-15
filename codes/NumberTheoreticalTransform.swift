/// NTT
/// FFTを適当にいじっただけ
/// verify: ATC001-C 高速フーリエ変換, 典型90問-065 RGB Balls 2
/// 単体で使う時は
/// var ntt = NTT()
/// ntt.numberTheoreticalTransform(&function: [ModInt], _ inverse: Bool)
struct NTT {
    //2^i乗根。
    var root: [ModInt] = Array(repeating: ModInt(3).toThePower(of: 119), count: 24)
    var rootInverse: [ModInt] = Array(repeating: ModInt(3).toThePower(of: 119), count: 24)
    init() {
        rootInverse[23] = 1/root[23]
        for i in (0...22).reversed() {
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
    func numberTheoreticalTransform(_ function: inout [ModInt], _ inverse: Bool = false){
        let size = function.count
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
    }
}