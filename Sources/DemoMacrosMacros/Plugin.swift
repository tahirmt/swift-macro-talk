import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SimpleMockPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MockMacro.self,
        StubMacro.self,
    ]
}
