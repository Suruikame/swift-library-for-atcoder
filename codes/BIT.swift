///Binary Indexed Tree
///初期化はvar bit = BIT<Element>(size)
///bit.sum(upTo k: Int)で0 ~ kまでの和を求める
///bit.add(value, to: index)でindexにvalueを加算
struct BIT<T: AdditiveArithmetic>{
    var elements: [T]
    var size: Int
    init(_ size: Int){
        elements = Array(repeating: T.zero, count: size)
        self.size = size
    }
    func sum(upTo k: Int) -> T{
        var res = T.zero
        var i = k
        while(i > 0){
            res += elements[i]
            i -= i & (-i)
        }
        return res
    }
    mutating func add(_ value: T, to: Int){
        var i = to
        while(i <= size){
            elements[i] += value
            i += i & (-i)
        }
    }
}