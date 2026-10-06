import Foundation

public struct StringJSONDecoder: Sendable {
    private let dec = JSONDecoder()

    public init() {}

    public func decode<T: Decodable>(_ type: T.Type, _ str: String) throws -> T {
        if type == String.self {
            return str as! T
        }
        return try decodeStringToJson(dec, type, str)
    }
}
