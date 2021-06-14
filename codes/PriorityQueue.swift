//二分ヒープ
//Min Heapなら{$0 < $1}
struct PriorityQueue<Element>{
    var elements: [Element] = []
    private var sz = 0//挿入位置
    var compareFunction: (Element, Element) -> Bool
    init(_ compareFunction: @escaping (Element, Element) -> Bool){
        self.compareFunction = compareFunction
    }
    func isEmpty() -> Bool{
        return sz == 0
    }
    func isNotEmpty() -> Bool{
        return sz != 0
    }
    func top() -> Element{
        return elements[0]
    }
    mutating func push(_ value: Element){
        var pos = sz//挿入暫定位置
        sz += 1
        if(sz >= elements.count){
            elements.append(value)
        }else{
            elements[pos] = value
        }
        while(pos != 0 && !compareFunction(elements[(pos-1)/2], value)){
            elements[pos] = elements[(pos-1)/2]
            pos = (pos-1)/2
        }
        elements[pos] = value
    }
    @discardableResult
    mutating func pop() -> Element{
        sz -= 1
        let res = elements[0]//根を取り出す
        var pos = 0//暫定位置
        let value = elements[sz]
        while(pos*2+1<sz){
            //根を下に下げていく
            var left = pos*2 + 1, right = pos*2+2
            if(right < sz && compareFunction(elements[right], elements[left])){
                left = right//右側が小さい時は右側と交換する
            }
            if(compareFunction(value, elements[left])){
                break//逆転していないなら抜ける
            }
            elements[pos] = elements[left]
            pos = left
        }
        elements[pos] = value
        return res
    }
}