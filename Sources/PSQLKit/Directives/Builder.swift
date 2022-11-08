// Builder.swift
// Copyright © 2022 hiimtmac

import Foundation

@resultBuilder
public struct Builder<T> {
    public typealias Component = [T]

    public static func buildBlock(
        _ content: Component...
    ) -> Component {
        content.flatMap { $0 }
    }

    public static func buildBlock(
        _ content: Component
    ) -> Component {
        content
    }

    public static func buildOptional(
        _ component: Component?
    ) -> Component {
        component ?? []
    }

    public static func buildEither(
        first component: Component
    ) -> Component {
        component
    }

    public static func buildEither(
        second component: Component
    ) -> Component {
        component
    }
}
