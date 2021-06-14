/// 最大流、最小費用流
/// 初期化は var flow = Flow(N) (Nは頂点数)。
/// addEdge(from, to, capacity, cost)をしてグラフを作る。
/// 最大流の時はcapacityまででok, 最小費用流を求める時はcostも入れる。
/// flow.dinic(from, to)で最大流の流量
/// flow.minCostFlow(from, to, f) (fは流量)でfを流した時の最小コスト
/// ToDo: dinicとminCostFlowを分ける
struct Flow {
    struct Queue<Element>{
        private var maxSize: Int
        private var elements: Array<Element?>
        init(_ size: Int = 1_000_000){
            maxSize = size
            elements = Array(repeating: nil, count: size)
        }
        private var head = 0
        private var tail = 0
    
        func isEmpty() -> Bool{
            return head == tail
        }
        func isNotEmpty() -> Bool {
            return !isEmpty()
        }
        func size() -> Int{
            return tail > head ? tail - head : tail + maxSize - head
        }
        mutating func pushFront(_ element: Element){
            assert(elements[tail] == nil, "Queue is full, but pushFront() method was called.")
            elements[(head-1+maxSize)%maxSize] = element
            head = (head-1+maxSize) % maxSize
        }
        mutating func pushBack(_ element: Element){
            assert(elements[tail] == nil, "Queue is full, but pushBack() method was called.")
            elements[tail] = element
            tail = (tail + 1) % maxSize
        }
        @discardableResult
        mutating func popFront() -> Element{
            assert(head != tail, "Queue is empty, but popFront() method was called.")
            let ret = elements[head]!
            elements[head] = nil
            head = (head + 1)%maxSize
            return ret
        }
        @discardableResult
        mutating func popBack() -> Element{
            assert(head != tail, "Queue is empty, but popBack() method was called")
            let ret = elements[(tail-1+maxSize)%maxSize]!
            elements[(tail-1+maxSize)%maxSize] = nil
            tail = (tail-1+maxSize)%maxSize
            return ret
        }
        mutating func front() -> Element{
            assert(elements[head] != nil, "Queue is empty, but front() method was called")
            return elements[head]!
        }
        mutating func back()-> Element{
            assert(elements[head] != nil, "Queue is empty, but back() method was called")
            return elements[(tail+maxSize-1) % maxSize]!
        }
        subscript(index: Int) -> Element {
            get {
                return elements[(head + index)%maxSize]!
            }
            set {
                elements[(head + index)%maxSize]! = newValue
            }
        }
    }
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
    struct Edge {
        var to: Int
        var capacity: Int
        var revesedEdgeIndex: Int
        var cost: Int
        init(_ to: Int, _ capacity: Int, _ revesedEdgeIndex: Int, _ cost: Int = 0) {
            self.to = to
            self.capacity = capacity
            self.revesedEdgeIndex = revesedEdgeIndex
            self.cost = cost
        }
    }
    let size: Int
    var graph: [[Edge]]
    var iter: [Int]
    var level: [Int]
    var potential: [Int]

    init(_ size: Int) {
        self.size = size
        self.graph = Array(repeating: [], count: size)
        self.iter = Array(repeating: 0, count: size)
        self.level = Array(repeating: -1, count: size)
        self.potential = Array(repeating: 0, count: size)
    }

    mutating func addEdge(_ from: Int, _ to: Int, _ capacity: Int = 1, _ cost: Int = 0) {
        graph[from].append(Edge(to, capacity, graph[to].count, cost))
        graph[to].append(Edge(from, 0, graph[from].count-1, -cost))
    }
    private mutating func bfs(_ s: Int) {
        var q = Queue<Int>()
        level = Array(repeating: -1, count: size)
        level[s] = 0
        q.pushBack(s)
        while(!q.isEmpty()) {
            let v = q.popFront()
            for i in graph[v] {
                if i.capacity > 0 && level[i.to] < 0 {
                    level[i.to] = level[v] + 1
                    q.pushBack(i.to)
                }
            }
        }
    }

    private mutating func dfs(_ v: Int, _ t: Int, _ f: Int) -> Int {
        if v == t {
            return f
        }
        for i in iter[v]..<graph[v].count {
            let edge = graph[v][i]
            if edge.capacity > 0 && level[v] < level[edge.to] {
                let d = dfs(edge.to, t, min(f, edge.capacity))
                if d > 0 {
                    graph[v][i].capacity -= d
                    graph[edge.to][edge.revesedEdgeIndex].capacity += d
                    return d
                }
            }
        }
        return 0
    }
    ///Dinic法
    ///最大流
    ///verify: ABC010D 浮気予防, ABC205F Grid and Tokens
    mutating func dinic(_ s: Int, _ t: Int) -> Int {
        var ret = 0
        while true {
            bfs(s)
            if level[t] < 0 {
                return ret
            }
            iter = Array(repeating: 0, count: size)
            var f = dfs(s, t, (1<<60))
            while f > 0 {
                ret += f
                f = dfs(s, t, (1<<60))
            }
        }
    }

    ///最小費用流
    ///指定した流量を達成できない時は-1を返す
    ///verify: ABC004D マーブル
    mutating func minCostFlow(_ s: Int, _ t: Int, _ f: Int) ->  Int {
        var ret = 0
        var flow = f
        var prev: [(vertix: Int, edge: Int)] = Array(repeating: (-1, -1), count: size)
        potential = Array(repeating: 0, count: size)
        while flow > 0 {
            var pq = PriorityQueue<(v: Int, d: Int)>({$0.d < $1.d})
            level = Array(repeating: (1<<60), count: size)
            level[s] = 0
            pq.push((s, 0))
            while(pq.isNotEmpty()) {
                let (v, d) = pq.pop()
                if level[v] != d {
                    continue
                }
                for i in 0..<graph[v].count {
                    let edge = graph[v][i]
                    let newDistance = d + edge.cost + potential[v] - potential[edge.to]
                    if edge.capacity > 0 && level[edge.to] > newDistance {
                        level[edge.to] = newDistance
                        prev[edge.to] = (v, i)
                        pq.push((edge.to, newDistance))
                    }
                }
            }
            if level[t] == (1<<60) {
                return -1
            }
            for i in 0..<size {
                potential[i] += level[i]
            }

            var d = flow
            var v = t
            while v != s {
                let (prevV, prevE) = prev[v]
                d = min(d, graph[prevV][prevE].capacity)
                v = prevV
            }
            flow -= d
            ret += d * potential[t]
            v = t
            while v != s {
                let (prevV, prevE) = prev[v]
                graph[prevV][prevE].capacity -= d
                graph[v][graph[prevV][prevE].revesedEdgeIndex].capacity += d
                v = prevV
            }
        }
        return ret
    }
}