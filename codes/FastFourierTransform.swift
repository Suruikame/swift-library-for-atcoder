/// 複素数による高速フーリエ変換
/// complex required
/// verify: ATC001-C 高速フーリエ変換
/// FFT単体で使う時は 
/// var fft = FFT()
/// fft.fastFourierTransform(_ &function: [Complex<Double>], _ inverse: Bool)
struct FFT {
    private func bitReverse(_ x: Int, _ k: Int) -> Int{
        var res = 0
        for i in 0..<k{
            res |= (x >> i & 1) << (k - 1 - i)
        }
        return res
    }
    func fastFourierTransform(_ function: inout [Complex<Double>], _ inverse: Bool = false){
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
        while(operationSize < size){
            for i in 0..<operationSize{
                let omega = Complex(length: 1.0, phase: Double.pi*Double(i)/Double(operationSize) * (inverse ? 1.0 : -1.0))
                var j = 0
                while(j < size){
                    let s = function[i + j], t = function[i + j + operationSize] * omega
                    function[i + j] = s + t
                    function[i + j + operationSize] = s - t
                    j += 2 * operationSize
                }
            }
            operationSize *= 2
        }
        if(inverse){
            function = function.map {$0 / Double(size)}
        }
    }
}
