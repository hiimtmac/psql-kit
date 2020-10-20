import Foundation
import SQLKit
import PostgresKit

protocol PSQLDateTime: Comparable, PSQLExpressible, Decodable, Encodable {
    var storage: Date { get }
    static var defaultFormatter: DateFormatter { get }
}

extension PSQLDateTime {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.storage < rhs.storage
    }
    
    public func serialize(to serializer: inout SQLSerializer) {
        Self.defaultFormatter.string(from: storage).serialize(to: &serializer)
        serializer.write("::")
        Self.postgresColumnType.serialize(to: &serializer)
    }
}

extension Date {
    public var psqlDate: PSQLDate { .init(self) }
    public var psqlTime: PSQLTime { .init(self) }
    public var psqlTimestamp: PSQLTimestamp { .init(self) }
    public var psqlTimestampZ: PSQLTimestampZ { .init(self) }
}

public struct PSQLDate: PSQLDateTime {
    let storage: Date
    
    init(_ date: Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}

extension PSQLDate: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .date }
}

extension PSQLDate: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

public struct PSQLTime: PSQLDateTime {
    let storage: Date
    
    public init(_ date: Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        fatalError("Not implemented")
    }()
}

extension PSQLTime: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .time }
}

extension PSQLTime: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

public struct PSQLTimestamp: PSQLDateTime {
    let storage: Date
    
    public init(_ date: Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        fatalError("Not implemented")
    }()
}

extension PSQLTimestamp: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}

extension PSQLTimestamp: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .timestamp }
}

public struct PSQLTimestampZ: PSQLDateTime {
    let storage: Date
    
    public init(_ date: Date = .init()) {
        self.storage = date
    }
    
    static let defaultFormatter: DateFormatter = {
        fatalError("Not implemented")
    }()
}

extension PSQLTimestampZ: PSQLExpressible {
    public typealias CompareType = Self
    public static var postgresColumnType: PostgresColumnType { .timestamptz }
}

extension PSQLTimestampZ: SelectSQLExpressible {
    public var selectSqlExpression: some SQLExpression { self }
}
