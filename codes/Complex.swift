import Foundation
///複素数
/// ToDo: verify
protocol RealNumber: SignedNumeric{
    static func / (lhs: Self, rhs: Self) -> Self
    static var multiplicationIdentity: Self {get}
}
//仮
extension Int: RealNumber{
    static let multiplicationIdentity: Int = 1
}
extension Double: RealNumber{
    static let multiplicationIdentity: Double = 1.0
}
struct Complex<T: RealNumber>{
    var value: (T, T)
    static var zero: Complex<T> {
        return Complex((T.zero, T.zero))
    }
    var real: T{
        return value.0
    }
    var imag: T{
        return value.1
    }
    var bar: Complex{
        return Complex((value.0, -value.1))
    }
    var absSquared: T{
        return value.0 * value.0 + value.1 * value.1
    }
    init(_ value: (T, T)){
        self.value = value
    }
    init(_ real: T, _ imag: T){
        self.value = (real, imag)
    }
    init(_ value: T){
        self.value = (value, T.zero)
    }
    static prefix func - (_ value: Complex) -> Complex{
        return Complex((-value.value.0, -value.value.1))
    }
    static func + (_ left: Complex, _ right: Complex) -> Complex{
        return Complex((left.value.0 + right.value.0, left.value.1 + right.value.1))
    }
    static func + (_ left: T, _ right: Complex) -> Complex{
        return Complex<T>(left) + right
    }
    static func + (_ left: Complex, _ right: T) -> Complex{
        return Complex<T>(right) + left
    }
    static func += (_ left: inout Complex, _ right: Complex){
        left = left + right
    }
    static func += (_ left: inout Complex, _ right: T){
        left = left + right
    }
    static func - (_ left: Complex, _ right: Complex) -> Complex{
        return left + -right
    }
    static func - (_ left: T, _ right: Complex) -> Complex{
        return left + -right
    }
    static func - (_ left: Complex, _ right: T) -> Complex{
        return left + -right
    }
    static func -= (_ left: inout Complex, _ right: Complex){
        left = left - right
    }
    static func -= (_ left: inout Complex, _ right: T){
        left = left - right
    }
    static func * (_ left: Complex, _ right: Complex) -> Complex{
        return Complex((left.value.0*right.value.0 - left.value.1*right.value.1, left.value.1*right.value.0 + left.value.0*right.value.1))
    }
    static func * (_ left: Complex, _ right: T) -> Complex{
        return left * Complex(right)
    }
    static func * (_ left: T, _ right: Complex) -> Complex{
        return Complex(left) * right
    }
    static func *= (_ left: inout Complex, _ right: Complex){
        left = left * right
    }
    static func *= (_ left: inout Complex, _ right: T){
        left = left * right
    }
    static func / (_ left: Complex, _ right: Complex) -> Complex{
        return (left*right.bar)/right.absSquared
    }
    static func / (_ left: Complex, _ right: T) -> Complex{
        return Complex(left.real/right, left.imag/right)
    }
    static func / (_ left: T, _ right: Complex) -> Complex{
        return Complex(left)/right
    }
    static func /= (_ left: inout Complex, _ right: Complex){
        left = left / right
    }
    static func /= (_ left: inout Complex, _ right: T){
        left = left / right
    }
    static func == (_ left: Complex, _ right: Complex) -> Bool{
        return (left.value == right.value)
    }
    static func == (_ left: Complex, _ right: T) -> Bool{
        return (left == Complex(right))
    }
    static func == (_ left: T, _ right: Complex) -> Bool{
        return (Complex(left) == right)
    }
}
extension Complex where T == Double{
    init(length: Double, phase: Double){
        value = (length*cos(phase), length*sin(phase))
    }
}
extension Int{
    var i: Complex<Int>{
        return Complex<Int>((0, self))
    }
}
extension Double{
    var i: Complex<Double>{
        return Complex<Double>((0, self))
    }
}
extension Complex: CustomStringConvertible{
    var description: String{
        let r = self.real, i = self.imag
        if(r == T.zero && i == T.zero){
            return "0"
        }else if(r == T.zero){
            return "\(self.value.1)i"
        }else if(i == T.zero){
            return "\(self.value.0)"
        }else if(i == T.multiplicationIdentity){
            return "\(self.value.0) + i"
        }else{
            return "\(self.value.0) + \(self.value.1)i"
        }
    }
}