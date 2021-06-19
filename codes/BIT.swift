/// Binary Indexed Tree (Fenwik Tree)
/// 1-indexedなので注意
/// bit.sum(upTo: k)で1~kまでの要素の和、bit.add(value, to: idx)でidxにvalueを加算
struct BIT<T: Numeric>{
    var elements: [T]
    var size: Int
    init(_ size: Int){
        elements = Array(repeating: T.zero, count: size+1)
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