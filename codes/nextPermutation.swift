///nextPermutation
///全部試したい時はsortすること！！！
///repeat{
///      処理
///}while(array.nextPermutation())
///でok
extension Array where Element: Comparable{
    mutating func nextPermutation() -> Bool{
        let size = self.count
        var front = size-2, back = size-1
        //sizeが1の時の動作はパスかassertかどちらでも
        /*
        if(size < 2){
            return false
        }*/
        assert(size >= 2, "Array should contain two or more elements to compute next permutation.")
        //昇順になっている箇所を探す
        while(front >= 0){
            if(self[front] < self[front + 1]){
                break
            }
            front -= 1
        }
        if(front < 0){
            return false
        }
        //self[front]より大きい要素を探す
        let frontNum = self[front]
        while(back >= 0){
            if(frontNum < self[back]){
                break
            }
            back -= 1
        }
        //入れ替え
        swapAt(front, back)
        //front+1以降を反転
        var i = 1
        while(front + i < size - i){
            swapAt(front + i, size - i)
            i += 1
        }
        return true
    }
}