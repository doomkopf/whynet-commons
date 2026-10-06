import Foundation

enum JsonError: Error {
    case General(String)
}

public func decodeStringToJson<T: Decodable>(_ dec: JSONDecoder, _ type: T.Type, _ str: String)
    throws -> T
{
    guard let data = str.data(using: .utf8) else {
        throw JsonError.General("Invalid string encoding")
    }
    return try dec.decode(type, from: data)
}
