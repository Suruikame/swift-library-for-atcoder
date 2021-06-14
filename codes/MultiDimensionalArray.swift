struct MultiDimensionalArray<Element>{
    var elements: [Element]
    var dim: Int
    var counts: [Int]
    private var countsForCalculatingIndex: [Int]
    init(counts: [Int], initialValue: Element){
        self.counts = counts
        dim = counts.count
        elements = Array(repeating: initialValue, count: counts.reduce(1, *))
        countsForCalculatingIndex = counts[1...] + [1] 
    }
    private func checkIndices(_ indices: [Int]) -> Bool{
        for (index, indexLimit) in zip(indices, counts){
            if index >= indexLimit{
                return false
            }
        }
        return true
    }
    private func convertIndex (_ indices : [Int]) -> Int{
        var res = 0
        for (index, count) in zip(indices, countsForCalculatingIndex){
            res = (res + index) * count
        }
        return res
    }
    subscript(_ indices: Int...) -> Element {
        get{
            assert(checkIndices(indices), "Index out of range")
            return elements[convertIndex(indices)]
        }
        set{
            assert(checkIndices(indices), "Index out of range")
            elements[convertIndex(indices)] = newValue
        }
    }
    subscript(_ indices: Int...) -> [Element]{
        get{
            let startIndex = convertIndex(indices)
            return Array(elements[startIndex..<startIndex+counts.last!])
        }
    }
}