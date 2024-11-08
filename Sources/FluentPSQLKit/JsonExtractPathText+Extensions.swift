// JsonExtractPathText+Extensions.swift
// Copyright (c) 2024 hiimtmac inc.

import FluentKit
import PSQLKit

extension JsonbExtractPathTextExpression {
    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, FieldProperty<T, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: keyPath].key.description,
            as: Content.self
        )
    }

    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, OptionalFieldProperty<T, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: keyPath].key.description,
            as: Content.self
        )
    }

    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, TimestampProperty<T, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: keyPath].$timestamp.key.description,
            as: Content.self
        )
    }

    public init<T>(
        _ group: ColumnExpression<T>,
        _ keyPath: KeyPath<T, IDProperty<T, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: keyPath].key.description,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, FieldProperty<U, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: first].key.description,
            U()[keyPath: second].key.description,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, OptionalFieldProperty<U, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: first].key.description,
            U()[keyPath: second].key.description,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, TimestampProperty<U, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: first].key.description,
            U()[keyPath: second].$timestamp.key.description,
            as: Content.self
        )
    }

    public init<T, U>(
        _ group: ColumnExpression<T>,
        _ first: KeyPath<T, GroupProperty<T, U>>,
        _ second: KeyPath<U, IDProperty<U, Content>>
    ) {
        self.init(
            group,
            T()[keyPath: first].key.description,
            U()[keyPath: second].key.description,
            as: Content.self
        )
    }
}
