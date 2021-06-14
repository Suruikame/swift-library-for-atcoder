///二分探索
///lowerBoundとupperBound
extension Array where Element: Comparable{
    func lowerBound(_ left: Int = 0, _ right: Int = -1, _ value: Element) -> Int{
        var  lb = left, ub = (right == -1) ? self.count: right
        while(ub > lb){
            let mid = lb + (ub - lb)/2
            if(self[mid] < value){
                lb = mid + 1
            }else{
                ub = mid
            }
        }
        return lb
    }
    func lowerBound(_ value: Element) -> Int {
        return self.lowerBound(0, -1, value)
    }
    func upperBound(_ left: Int = 0, _ right: Int = -1, _ value: Element) -> Int{
        var  lb = left, ub = (right == -1) ? self.count: right
        while(ub > lb){
            let mid = lb + (ub - lb)/2
            if(self[mid] <= value){
                lb = mid + 1
            }else{
                ub = mid
            }
        }
        return lb
    }
    func upperBound(_ value: Element) -> Int {
        return self.lowerBound(0, -1, value)
    }
}