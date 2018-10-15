//
//  SyntaxFactoryExtensions.swift
//  SwiftSyntax
//
//  Created by Paul Taykalo on 10/14/18.
//

import SwiftSyntax

public extension SyntaxFactory {

    public static func makeGuardStmt(conditions: ConditionElementListSyntax, body: CodeBlockSyntax) -> GuardStmtSyntax {
        return makeGuardStmt(guardKeyword: makeGuardKeyword(), conditions: conditions, elseKeyword: makeElseKeyword(), body: body)
    }

    public static func makeCodeBlock(statements: CodeBlockItemListSyntax) -> CodeBlockSyntax {
        return makeCodeBlock(leftBrace: makeLeftBraceToken(), statements: statements, rightBrace: makeRightBraceToken())
    }

    public static func makeCodeBlock(_ statements: [CodeBlockItemSyntax]) -> CodeBlockSyntax {
        return makeCodeBlock(leftBrace: makeLeftBraceToken(), statements: makeCodeBlockItemList(statements), rightBrace: makeRightBraceToken())
    }

    public static func makeCodeBlock(_ statement: CodeBlockItemSyntax) -> CodeBlockSyntax {
        return makeCodeBlock(leftBrace: makeLeftBraceToken(), statements: makeCodeBlockItemList([statement]), rightBrace: makeRightBraceToken())
    }

    public static func makeCodeBlock(_ statement: Syntax) -> CodeBlockSyntax {
        return makeCodeBlock(makeCodeBlockItem(item: statement, semicolon: nil))
    }

    public static func makeCodeBlockItemList(
        _ elements: [Syntax]) -> CodeBlockItemListSyntax {
        return makeCodeBlockItemList(elements.map { makeCodeBlockItem(item: $0, semicolon: nil)})
    }

    public static func makeReturnStmt(_ expression: ExprSyntax? = nil) -> ReturnStmtSyntax {
        return makeReturnStmt(returnKeyword: makeReturnKeyword(), expression: expression)
    }

}
