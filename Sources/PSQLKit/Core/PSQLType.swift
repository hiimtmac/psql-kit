import Foundation

enum PSQLType: String {
    case uuid
    case text
    case integer
    case decimal
    case date
    case boolean
    case timestamp
    case timestampz
    case interval
    
    var psqlValue: String {
        switch self {
        case .decimal: return "float8"
        default: return rawValue
        }
    }
}
