///セグメント木
/// ToDo: minIndexQueryとかへの対応
struct SegmentTree<Element> {
    private var elements: [Element] = []
    private var n: Int = 0
    private let fxx: (Element, Element) -> Element
    private let ex: Element

    init(fxx: @escaping (Element, Element) -> Element, ex: Element) {
         self.fxx = fxx
         self.ex = ex
    }
    mutating func build(_ elements: [Element]) {
        self.n = elements.count+1
        self.elements = Array(repeating: ex, count: n) + elements + [ex]
        for i in (1..<n).reversed() {
            self.elements[i] = fxx(self.elements[i << 1], self.elements[i << 1 | 1])
        }
    }

    //値を変更
    mutating func update(at index: Int, to value: Element) {
        let index = index + n
        elements[index] = value
        recalculate(at: index)
    }
    private mutating func recalculate(at index: Int) {
        var index = index >> 1
        while index > 0 {
            elements[index] = fxx(elements[index << 1], elements[index << 1 | 1])
            index >>= 1
        }
    }
    func rangeQuery(_ l: Int, _ r: Int) -> Element {
        var left = l+n
        var right = r+n
        var ret = (ex, ex)
        while right - left > 0 {
            if left & 1 == 1 {
                ret.0 = fxx(ret.0, elements[left])
                left += 1
            }
            left >>= 1
            if right&1 == 1 {
                right -= 1
                ret.1 = fxx(elements[right], ret.1)
            }
            right >>= 1
        }
        return fxx(ret.0, ret.1)
    }
}