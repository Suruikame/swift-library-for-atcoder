///Complex and fast_fourier_transfrom are required
func convolution(_ fin: [Complex<Double>], _ gin: [Complex<Double>]) -> [Double]{
    var size = 1
    var f = fin, g = gin
    let tmpSize = f.count + g.count
    while(size < tmpSize){
        size *= 2
    }
    f += Array(repeating: Complex(0.0), count: size - f.count)
    g += Array(repeating: Complex(0.0), count: size - g.count)
    fastFourierTransform(&f); fastFourierTransform(&g); 
    for i in 0..<size{
        f[i] *= g[i]
    }
    fastFourierTransform(&f, true)
    return f.map {$0.real}
}