import Foundation

struct SimpleDate {
    let storage: Date
    
    init(_ date: Date = .init()) {
        self.storage = Calendar.current.startOfDay(for: date)
    }
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(abbreviation: "UTC")
        return f
    }()
}

extension SimpleDate: PSQLable {
    static var psqlType: PSQLType { .date }
    
    func serialize(to serializer: inout PSQLSerializer) {
        let date = formatter.string(from: storage)
        date.serialize(to: &serializer)
    }
}

extension SimpleDate: TypeComparable {
    typealias T = Self
    var select: PSQLExpression { self }
}

extension SimpleDate: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}

struct TimestampDate {
    let storage: Date
    
    init(_ date: Date = .init()) {
        self.storage = date
    }
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd hh:mm a"
        f.timeZone = TimeZone(abbreviation: "UTC")
        return f
    }()
}

extension TimestampDate: PSQLable {
    static var psqlType: PSQLType { .timestamp }
    
    func serialize(to serializer: inout PSQLSerializer) {
        let date = formatter.string(from: storage)
        date.serialize(to: &serializer)
    }
}

extension TimestampDate: TypeComparable {
    typealias T = Self
    var select: PSQLExpression { self }
}

extension TimestampDate: ExpressibleAsCompare {
    var compare: PSQLExpression { self }
}
