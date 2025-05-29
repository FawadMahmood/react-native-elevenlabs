import Foundation

@objc(SwiftElevenlabs)
class SwiftElevenlabs: NSObject {
    @objc
    func multiply(a: Double, b: Double) -> NSNumber {
        return NSNumber(value: a * b)
    }
}
