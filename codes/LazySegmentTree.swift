///遅延評価セグメント木
/// ToDo: minIndexQueryとかへの対応
struct LazySegmentTree<Element, Operator> {
    private var elements: [Element] = []
    private var lazyTree: [Operator] = []
    private var n: Int = 0
    private let fxx: (Element, Element) -> Element
    private let fxm: (Element, Operator) -> Element
    private let fmm: (Operator, Operator) -> Operator
    private let ex: Element
    private let em: Operator

    init(fxx: @escaping (Element, Element) -> Element, fxm: @escaping (Element, Operator) -> Element,
     fmm: @escaping (Operator, Operator) -> Operator, ex: Element, em: Operator) {
         self.fxx = fxx
         self.fxm = fxm
         self.fmm = fmm
         self.ex = ex
         self.em = em
    }

    mutating func build(repeating initialValue: Element, count n: Int) {
        self.elements = Array(repeating: initialValue, count: 2*n+2)
        self.lazyTree = Array(repeating: em, count: 2*n+2)
        self.n = n
    }
    mutating func build(_ elements: [Element]) {
        self.n = elements.count
        self.elements = Array(repeating: ex, count: n+1) + elements + [ex]
        self.lazyTree = Array(repeating: em, count: 2*n+2)
        for i in (1...n).reversed() {
            self.elements[i] = fxx(self.elements[i << 1], self.elements[i << 1 | 1])
        }
    }

    //値を変更
    mutating func update(at index: Int, to value: Element) {
        let index = index + n
        propagateContainers(at: index)
        elements[index] = value
        lazyTree[index] = em
        recalculate(at: index)
    }

    @discardableResult
    private mutating func propagate(at index: Int) -> Element {
        //自分に作用
        elements[index] = fxm(elements[index], lazyTree[index])
        let l = index << 1, r = index << 1 | 1
        //子に伝搬
        if l < 2*n+2{
            lazyTree[l] = fmm(lazyTree[l], lazyTree[index])
        }
        if r < 2*n+2{
            lazyTree[r] = fmm(lazyTree[r], lazyTree[index])
        }
        //自分の要素を初期化
        lazyTree[index] = em
        return elements[index]
    }

    //自分を含む区間をトップダウンに伝搬
    private mutating func propagateContainers(at index: Int) {
        if index < 1 {
            return
        }
        for i in (1..<bitLength(of: index)).reversed() {
            propagate(at: (index >> i))
        }
    }

    //自分を含む区間をボトムアップに更新(再計算)
    private mutating func recalculate(at index: Int) {
        var index = index
        while index > 1 {
            index >>= 1
            elements[index] = fxx(propagate(at: index << 1), propagate(at: index << 1 | 1))
        }
    }

    //[left, right)の区間にvalueを作用させる。
    mutating func operateRange(_ left: Int, _ right: Int, _ value: Operator) {
        if left == right {
            return
        }
        var left = left + n, right = right + n
        let startingLeft = left >> left.trailingZeroBitCount
        let startingRight = (right >> right.trailingZeroBitCount) - 1
        propagateContainers(at: startingLeft)
        propagateContainers(at: startingRight)
        while left < right {
            if left & 1 == 1 {
                lazyTree[left] = fmm(lazyTree[left], value)
                left += 1
            }
            if right & 1 == 1 {
                right -= 1
                lazyTree[right] = fmm(lazyTree[right], value)
            }
            left >>= 1
            right >>= 1
        }
        recalculate(at: startingLeft)
        recalculate(at: startingRight)
    }

    //クエリに答える
    mutating func query(_ left: Int, _ right: Int) -> Element {
        if left == right {
            return ex
        }
        var left = left + n, right = right + n
        propagateContainers(at: left >> left.trailingZeroBitCount)
        propagateContainers(at: (right >> right.trailingZeroBitCount)-1)
        var res: (left: Element, right: Element) = (ex, ex)
        while left < right {
            if left & 1 == 1 {
                res.left = fxx(res.left, propagate(at: left))
                left += 1
            }
            if right & 1 == 1 {
                right -= 1
                res.right = fxx(propagate(at: right), res.right)
            }
            left >>= 1
            right >>= 1
        }
        return fxx(res.left, res.right)
    }

    private func bitLength(of n: Int) -> Int {
        return n.bitWidth - n.leadingZeroBitCount
    }
}