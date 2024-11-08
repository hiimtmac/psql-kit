// TableMacro.swift
// Copyright (c) 2024 hiimtmac inc.

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum TableMacro {
    enum TableMacroError: Error, CustomStringConvertible {
        case nonStruct

        var description: String {
            switch self {
            case .nonStruct: "@Table can only be applied to `struct`s"
            }
        }
    }
}

extension TableMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let publicKeyword = TokenSyntax.keyword(.public)
        let publicMod = DeclModifierSyntax(name: .keyword(.public))
        let staticMod = DeclModifierSyntax(name: .keyword(.static))

        guard
            let identified = declaration.asProtocol(NamedDeclSyntax.self),
            let structDecl = identified.as(StructDeclSyntax.self)
        else {
            throw TableMacroError.nonStruct
        }

        guard
            let attribute = structDecl.attributes.first?.as(AttributeSyntax.self),
            let argumentList = attribute.arguments?.as(LabeledExprListSyntax.self),
            let tableArgument = argumentList.first,
            let tableExpression = tableArgument.expression.as(StringLiteralExprSyntax.self),
            let tableSegment = tableExpression.segments.first?.as(StringSegmentSyntax.self)
        else {
            return []
        }

        let schemaInitializer = if
            argumentList.count > 1,
            let schemaArgument = argumentList.last,
            let schemaExpression = schemaArgument.expression.as(StringLiteralExprSyntax.self),
            let schemaSegment = schemaExpression.segments.first?.as(StringSegmentSyntax.self)
        {
            InitializerClauseSyntax(
                equal: .equalToken(),
                value: StringLiteralExprSyntax(
                    openingQuote: .stringQuoteToken(),
                    segments: StringLiteralSegmentListSyntax(
                        arrayLiteral: StringLiteralSegmentListSyntax.Element(
                            StringSegmentSyntax(
                                content: .stringSegment(schemaSegment.content.text)
                            )
                        )
                    ),
                    closingQuote: .stringQuoteToken()
                )
            )
        } else {
            InitializerClauseSyntax(
                equal: .equalToken(),
                value: NilLiteralExprSyntax(nilKeyword: .keyword(.nil))
            )
        }

        let isPublic = structDecl.modifiers.contains(where: { $0.name.text == publicKeyword.text })

        let tableName = MemberBlockItemListSyntax.Element(
            decl: VariableDeclSyntax(
                modifiers: isPublic
                    ? DeclModifierListSyntax(arrayLiteral: publicMod, staticMod)
                    : DeclModifierListSyntax(arrayLiteral: staticMod),
                bindingSpecifier: .keyword(.let),
                bindings: PatternBindingListSyntax(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(
                            identifier: .identifier("tableName")
                        ),
                        typeAnnotation: TypeAnnotationSyntax(
                            colon: .colonToken(),
                            type: IdentifierTypeSyntax(
                                name: .identifier("String")
                            )
                        ),
                        initializer: InitializerClauseSyntax(
                            equal: .equalToken(),
                            value: StringLiteralExprSyntax(
                                openingQuote: .stringQuoteToken(),
                                segments: StringLiteralSegmentListSyntax(
                                    arrayLiteral: StringLiteralSegmentListSyntax.Element(
                                        StringSegmentSyntax(
                                            content: .stringSegment(tableSegment.content.text)
                                        )
                                    )
                                ),
                                closingQuote: .stringQuoteToken()
                            )
                        )
                    )
                )
            )
        )

        let schemaName = MemberBlockItemListSyntax.Element(
            decl: VariableDeclSyntax(
                modifiers: isPublic
                    ? DeclModifierListSyntax(arrayLiteral: publicMod, staticMod)
                    : DeclModifierListSyntax(arrayLiteral: staticMod),
                bindingSpecifier: .keyword(.let),
                bindings: PatternBindingListSyntax(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(
                            identifier: .identifier("schemaName")
                        ),
                        typeAnnotation: TypeAnnotationSyntax(
                            colon: .colonToken(),
                            type: OptionalTypeSyntax(
                                wrappedType: IdentifierTypeSyntax(
                                    name: .identifier("String")
                                ),
                                questionMark: .postfixQuestionMarkToken()
                            )
                        ),
                        initializer: schemaInitializer
                    )
                )
            )
        )

        let queryContainer = MemberBlockItemListSyntax.Element(
            decl: VariableDeclSyntax(
                modifiers: isPublic
                    ? DeclModifierListSyntax(arrayLiteral: publicMod, staticMod)
                    : DeclModifierListSyntax(arrayLiteral: staticMod),
                bindingSpecifier: .keyword(.let),
                bindings: PatternBindingListSyntax(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(
                            identifier: .identifier("queryContainer")
                        ),
                        initializer: InitializerClauseSyntax(
                            equal: .equalToken(),
                            value: FunctionCallExprSyntax(
                                calledExpression: DeclReferenceExprSyntax(
                                    baseName: .identifier("QueryContainer")
                                ),
                                leftParen: .leftParenToken(),
                                arguments: LabeledExprListSyntax(),
                                rightParen: .rightParenToken(),
                                additionalTrailingClosures: MultipleTrailingClosureElementListSyntax()
                            )
                        )
                    )
                )
            )
        )

        let tableRecord = ExtensionDeclSyntax(
            extensionKeyword: .keyword(.extension),
            extendedType: IdentifierTypeSyntax(name: .identifier(structDecl.name.text)),
            inheritanceClause: InheritanceClauseSyntax(
                colon: .colonToken(),
                inheritedTypes: InheritedTypeListSyntax(
                    arrayLiteral: InheritedTypeListSyntax.Element(
                        type: IdentifierTypeSyntax(
                            name: .identifier("Table")
                        )
                    )
                )
            ),
            memberBlock: MemberBlockSyntax(
                leftBrace: .leftBraceToken(),
                members: MemberBlockItemListSyntax(
                    arrayLiteral: tableName, schemaName, queryContainer
                ),
                rightBrace: .rightBraceToken()
            )
        )

        return [tableRecord]
    }
}

extension TableMacro: MemberMacro {
    struct ColumnInfo {
        let variableName: String
        let columnName: String
        let type: String
        let isPublic: Bool
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let publicKeyword = TokenSyntax.keyword(.public)
        let publicMod = DeclModifierSyntax(name: .keyword(.public))

        guard
            let identified = declaration.asProtocol(NamedDeclSyntax.self),
            let structDecl = identified.as(StructDeclSyntax.self)
        else {
            throw TableMacroError.nonStruct
        }

        let isPublic = structDecl.modifiers.contains(where: { $0.name.text == publicKeyword.text })

        let columnList = declaration
            .memberBlock
            .members
            .compactMap { member -> ColumnInfo? in
                guard
                    let variable = member.decl.as(VariableDeclSyntax.self),
                    let binding = variable.bindings.first,
                    // is a non-computed property
                    binding.accessorBlock == nil,
                    let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
                    let typeAnnotation = binding.typeAnnotation?.type
                else {
                    return nil
                }

                let columnName: String
                if
                    let attribute = variable.attributes.first?.as(AttributeSyntax.self),
                    let attributeName = attribute.attributeName.as(IdentifierTypeSyntax.self)
                {
                    if attributeName.name.text == "CTEIgnore" {
                        return nil
                    } else if
                        attributeName.name.text == "CTECol",
                        let argumentList = attribute.arguments?.as(LabeledExprListSyntax.self),
                        let argument = argumentList.first,
                        let expression = argument.expression.as(StringLiteralExprSyntax.self),
                        let segment = expression.segments.first?.as(StringSegmentSyntax.self)
                    {
                        columnName = segment.content.text
                    } else {
                        return nil
                    }
                } else {
                    columnName = identifier.identifier.text
                }

                let type: String
                if let simple = typeAnnotation.as(IdentifierTypeSyntax.self) {
                    type = simple.name.text
                } else if let member = typeAnnotation.as(MemberTypeSyntax.self), let base = member.baseType.as(IdentifierTypeSyntax.self) {
                    type = "\(base.name.text).\(member.name.text)"
                } else if let optional = typeAnnotation.as(OptionalTypeSyntax.self)?.wrappedType {
                    if let simple = optional.as(IdentifierTypeSyntax.self) {
                        type = simple.name.text
                    } else if let member = optional.as(MemberTypeSyntax.self), let base = member.baseType.as(IdentifierTypeSyntax.self) {
                        type = "\(base.name.text).\(member.name.text)"
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }

                let isPublic = variable.modifiers.contains(where: { $0.name.text == publicKeyword.text })

                return .init(
                    variableName: identifier.identifier.text,
                    columnName: columnName,
                    type: type,
                    isPublic: isPublic
                )
            }

        let columnAccessors = columnList.map { columnInfo -> MemberBlockItemSyntax in
            MemberBlockItemSyntax(
                decl: VariableDeclSyntax(
                    attributes: AttributeListSyntax(
                        arrayLiteral: AttributeListSyntax.Element(
                            AttributeSyntax(
                                atSign: .atSignToken(),
                                attributeName: IdentifierTypeSyntax(
                                    name: .identifier("ColumnAccessor"),
                                    genericArgumentClause: GenericArgumentClauseSyntax(
                                        leftAngle: .leftAngleToken(),
                                        arguments: GenericArgumentListSyntax(
                                            arrayLiteral: GenericArgumentSyntax(
                                                argument: IdentifierTypeSyntax(
                                                    name: .identifier(columnInfo.type)
                                                )
                                            )
                                        ),
                                        rightAngle: .rightAngleToken()
                                    )
                                ),
                                leftParen: .leftParenToken(),
                                arguments: AttributeSyntax.Arguments(
                                    LabeledExprListSyntax(
                                        arrayLiteral: LabeledExprSyntax(
                                            expression: StringLiteralExprSyntax(
                                                openingQuote: .stringQuoteToken(),
                                                segments: StringLiteralSegmentListSyntax(
                                                    arrayLiteral: StringLiteralSegmentListSyntax.Element(
                                                        StringSegmentSyntax(
                                                            content: .stringSegment(columnInfo.columnName)
                                                        )
                                                    )
                                                ),
                                                closingQuote: .stringQuoteToken()
                                            )
                                        )
                                    )
                                ),
                                rightParen: .rightParenToken()
                            )
                        )
                    ),
                    modifiers: columnInfo.isPublic
                        ? DeclModifierListSyntax(arrayLiteral: publicMod)
                        : DeclModifierListSyntax(),
                    bindingSpecifier: .keyword(.var),
                    bindings: PatternBindingListSyntax(
                        arrayLiteral: PatternBindingSyntax(
                            pattern: IdentifierPatternSyntax(
                                identifier: .identifier(columnInfo.variableName)
                            ),
                            typeAnnotation: TypeAnnotationSyntax(
                                colon: .colonToken(),
                                type: IdentifierTypeSyntax(
                                    name: .identifier("Never")
                                )
                            )
                        )
                    )
                )
            )
        }

        let query = DeclSyntax(
            StructDeclSyntax(
                attributes: AttributeListSyntax(),
                modifiers: isPublic
                    ? DeclModifierListSyntax(arrayLiteral: publicMod)
                    : DeclModifierListSyntax(),
                structKeyword: .keyword(.struct),
                name: .identifier("QueryContainer"),
                memberBlock: MemberBlockSyntax(
                    leftBrace: .leftBraceToken(),
                    members: MemberBlockItemListSyntax(columnAccessors),
                    rightBrace: .rightBraceToken()
                )
            )
        )

        return [query]
    }
}
