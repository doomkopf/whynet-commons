import Foundation

public struct StringJSONEncoder: Sendable {
    private let enc = JSONEncoder()

    public init() {}

    public func encode(_ object: Encodable) throws -> String {
        if object is String {
            return object as! String
        }
        return String(data: try enc.encode(object), encoding: .utf8)!
    }
}
