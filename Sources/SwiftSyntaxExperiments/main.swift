import SwiftSyntax
import Foundation


private struct SyntaxHandler<Source, Dest> {
    let match :(Source) -> (Bool)
    let rewriter: (Source) -> Dest
}

class CustomRewriter: SyntaxRewriter {

    private var functionsHandler: SyntaxHandler<FunctionDeclSyntax,DeclSyntax>?


    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        guard let handler = functionsHandler, handler.match(node) else { return node }
        return handler.rewriter(node)
    }

    func rewriteFunctions(
        matching: @escaping (FunctionDeclSyntax) -> (Bool) = { _  in return true },
        with rewriter: @escaping  (FunctionDeclSyntax) -> DeclSyntax
        ) {
        functionsHandler = SyntaxHandler(match: matching, rewriter: rewriter )
    }

    func interestingFunction() {
        if (true) {
            print("COOL")
            print("COOLER")
        }
    }
}

class ClosureVisitor: SyntaxVisitor {
    var ident: Int = 0
    override func visitPre(_ node: Syntax) {
        let id = String(repeating: "  ", count: ident)
        print("[ENTER] -> \(id)\(type(of:node))")
        ident += 1
    }
    override func visitPost(_ node: Syntax) {
        ident -= 1
        let id = String(repeating: "  ", count: ident)
        print("[OUT  ] <- \(id)\(type(of:node))")
    }

    override func visit(_ token: TokenSyntax) {
        let id = String(repeating: "  ", count: ident)
        print("[TOKEN] <- \(id)\(token.withoutTrivia())")
    }
}

let parser = try! SyntaxTreeParser.parse(URL(fileURLWithPath: #file))
let syntax = parser.root

private extension SyntaxFactory {

    static func rewriteIfToGurad(expression: CodeBlockSyntax) -> CodeBlockSyntax {
        guard let ifstatement = expression.only({ $0 as? IfStmtSyntax}) else { return expression }
        let guardSyntax = makeGuardStmt(
            conditions: ifstatement.conditions,
            body: makeCodeBlock(makeReturnStmt())
        )
        return expression.withStatements(
            makeCodeBlockItemList([
                guardSyntax,
                ifstatement.body.statements
                ])
        )
    }
}

let rewriter = CustomRewriter()
rewriter.rewriteFunctions(
    matching: { (f: FunctionDeclSyntax) -> Bool in
        guard let ifStatement = f.only({ $0 as? IfStmtSyntax}) else { return false }
        return ifStatement.elseBody == nil
},
    with: { function in
        guard let body = function.body else { return function }
        let guardSyntax = SyntaxFactory.rewriteIfToGurad(expression: body)
        return function.withBody(guardSyntax)
})

let updatedSyntax = rewriter.visit(syntax)
print(updatedSyntax)

