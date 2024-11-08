// QueryDirective+Extensions.swift
// Copyright (c) 2024 hiimtmac inc.

import PSQLKit

extension QueryDirective {
    public func asSubquery<U>(_ table: U) -> SubQuery<T> where U: FluentCTE {
        SubQuery(name: type(of: table).schema, content: self.content)
    }

    public func asSubquery<U>(_ alias: FluentCTEAlias<U>) -> SubQuery<T> where U: FluentCTE {
        SubQuery(name: alias.alias, content: self.content)
    }
}

extension QueryDirective {
    public func asWith<U>(_ table: U) -> WithQuery<T> where U: FluentCTE {
        WithQuery(name: type(of: table).schema, content: self.content)
    }

    public func asWith<U>(_ alias: FluentCTEAlias<U>) -> WithQuery<T> where U: FluentCTE {
        WithQuery(name: alias.alias, content: self.content)
    }
}
