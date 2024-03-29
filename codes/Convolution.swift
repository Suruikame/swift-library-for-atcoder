/// 畳み込み
/// 複素数 + FFTかModInt + NTTが必要
/// 使う方だけをコピペ。
/// 使い方は
/// convolute(f, g)
func convolute(_ f: [Complex<Double>], _ g: [Complex<Double>]) -> [Double]{
    let fft = FFT()
    var size = 1
    var f = f, g = g
    let tmpSize = f.count + g.count
    while(size < tmpSize){
        size *= 2
    }
    f += Array(repeating: Complex(0.0), count: size - f.count)
    g += Array(repeating: Complex(0.0), count: size - g.count)
    f = fft.fastFourierTransform(f)
    g = fft.fastFourierTransform(g); 
    for i in 0..<size{
        f[i] *= g[i]
    }
    return fft.fastFourierTransform(f, true).map {$0.real}
}

func convolute(_ f: [ModInt], _ g: [ModInt]) -> [ModInt]{
    let ntt = NTT()
    var size = 1
    var f = f, g = g
    let tmpSize = f.count + g.count
    while(size < tmpSize){
        size *= 2
    }
    f += Array(repeating: ModInt(0), count: size - f.count)
    g += Array(repeating: ModInt(0), count: size - g.count)
    f = ntt.numberTheoreticalTransform(f)
    g = ntt.numberTheoreticalTransform(g)
    for i in 0..<size{
        f[i] *= g[i]
    }
    return ntt.numberTheoreticalTransform(f, true)
}