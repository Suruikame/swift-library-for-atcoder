///重みつきUnionFind
struct weightedUnionFind{
    var tree: [Int]
    var diffWeight: [Int]
    var size: Int
    init(_ size: Int){
        tree = Array(repeating: -1, count: size)
        diffWeight = Array(repeating: 0, count: size)
        self.size = size
    } 

    mutating func root(of idx: Int)-> Int{
        var weight = 0
        var current = idx
        while(tree[current] >= 0){
            weight += diffWeight[current]
            current = tree[current]
        }
        diffWeight[idx] = weight
        tree[idx] = current
        return current
    }

    mutating func isSame(_ x: Int, _ y: Int) -> Bool{
        return root(of: x) == root(of: y)
    }
    mutating func weight(_ x: Int) -> Int{
        _ = root(of: x)
        return diffWeight[x]
    }
    mutating func difference(_ x: Int, _ y: Int) -> Int{
        return (weight(y) - weight(x))
    } 
    mutating func size(of x: Int) -> Int{
        return -tree[root(of: x)]
    }
    mutating func unite(_ X: Int, _ Y: Int, _ W: Int) -> Bool{
        var x = root(of: X), y = root(of: Y)
        if(isSame(x, y)){
            return false
        }
        var w = W + weight(x) - weight(y)
        if(tree[x] > tree[y]){
            swap(&x, &y)
            w = -w
        }
        tree[x] += tree[y]
        tree[y] = x
        diffWeight[y] = w
        return true

    }
}