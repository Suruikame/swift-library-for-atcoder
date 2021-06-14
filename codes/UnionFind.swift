struct UnionFind{
    var parent: Array<Int> = []
    init(_ size: Int){
        parent = Array(repeating: -1, count: size)
    }
    func root(of: Int) -> Int{
        if(parent[of] < 0){
            return of
        }else{
            return root(of: parent[of])
        }
    }
    func size(of: Int) -> Int{
        return -parent[root(of: of)]
    }
    func same(_ x: Int, _ y: Int) -> Bool{
        return root(of: x) == root(of: y)
    }
    @discardableResult
    mutating func unite(_ x: Int, _ y: Int) -> Bool{
        if(same(x, y)){
            return false
        }
        let rootOfX = root(of: x), rootOfY = root(of: y)
        if(size(of: x) < size(of: y)){
            parent[rootOfY] += parent[rootOfX]
            parent[rootOfX] = rootOfY
        }else{
            parent[rootOfX] += parent[rootOfY]
            parent[rootOfY] = rootOfX
        }
        return true
    }
}