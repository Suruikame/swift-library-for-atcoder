struct Queue<Element> {
    private var maxSize: Int
    private var elements: Array<Element?>
    init(_ size: Int = 1_000_000){
        maxSize = size
        elements = Array(repeating: nil, count: size)
    }
    private var head = 0
    private var tail = 0

    mutating func initialize() {
        head = 0
        tail = 0
    }
    func isEmpty() -> Bool {
        return head == tail
    }
    func isNotEmpty() -> Bool {
        return !isEmpty()
    }
    func size() -> Int {
        return tail > head ? tail - head : tail + maxSize - head
    }
    mutating func pushFront(_ element: Element) {
        var i = head-1+maxSize
        if i >= maxSize {
            i -= maxSize
        }
        elements[i] = element
        head = i
    }
    mutating func pushBack(_ element: Element) {
        elements[tail] = element
        tail = tail + 1
        if tail >= maxSize {
            tail = 0
        }
    }
    @discardableResult
    mutating func popFront() -> Element {
        let ret = elements[head]!
        head = head + 1
        if head >= maxSize {
            head = 0
        }
        return ret
    }
    @discardableResult
    mutating func popBack() -> Element {
        var i = head-1+maxSize
        if i >= maxSize {
            i -= maxSize
        }
        let ret = elements[i]!
        tail = i
        return ret
    }
    mutating func front() -> Element {
        return elements[head]!
    }
    mutating func back()-> Element {
        var i = head-1+maxSize
        if i >= maxSize {
            i -= maxSize
        }
        return elements[i]!
    }
    subscript(index: Int) -> Element {
        get {
            var i = head-1+maxSize
            if i >= maxSize {
                i -= maxSize
            }
            return elements[i]!
        }
        set {
            var i = head-1+maxSize
            if i >= maxSize {
                i -= maxSize
            }
            elements[i]! = newValue
        }
    }
}