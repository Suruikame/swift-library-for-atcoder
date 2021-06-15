///進数変換
///valueが10進法表記されていると見て変換する
///結果は小さい順なので注意 (11を2進数へ変換すると1011だが、[1,1,0,1]で返す。)
func baseConvert(_ value: Int, to: Int) -> [Int]{
    /* For safty
    guard abs(to) > 1 else {
        print("base must not be -1, 0, or 1")
        abort()
    }*/
    var x = value
    if(x == 0){
        return [0]
    }
    var res: [Int] = []
    let base = abs(to)
    while(x != 0){
        let tmp = ((x%base)+base)%base
        res.append(tmp)
        x = (x-tmp) / to
    }
    return res
}