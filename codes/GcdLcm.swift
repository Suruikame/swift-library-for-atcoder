//最大公約数、最小公倍数
func gcd(_ val1: Int, _ val2: Int) -> Int{
    var (x, y) = (val1, val2)
    if(x < y){
        swap(&x, &y)
    }
    if(x % y == 0){
        return y
    }
    return gcd(y, x%y)
}

func lcm(_ val1: Int, _ val2: Int) -> Int{
    return val1 / gcd(val1, val2) * val2
}

//拡張ユークリッドの互除法
//ax + by = gcd(a, b)
//x, yを参照渡しで解を求め、gcg(a, b)を返す
func extendedGCD(_ a: Int, _ b: Int, _ x: inout Int, _ y: inout Int) -> Int{
    if(b == 0){
        x = 1
        y = 0
        return a
    }
    let q = a/b
    let g = extendedGCD(b, a - q*b, &x, &y)
    let z = x - q*y
    x = y
    y = z
    return g
}

//aのmodに関する逆元を返す。aとmodは互いに素であることが必要
func inverseMod(_ a: Int, _ m: Int) -> Int{
    var x: Int = 0
    var y: Int = 0
    _ = extendedGCD(a, m, &x, &y)
    x %= m
    if(x < 0){
        x += m
    }
    return x
}