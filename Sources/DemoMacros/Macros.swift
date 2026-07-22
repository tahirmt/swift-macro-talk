
@attached(peer, names: prefixed(Mock))
public macro Mock() = #externalMacro(module: "DemoMacrosMacros", type: "MockMacro")

@attached(extension, names: named(stub))
public macro Stub() = #externalMacro(module: "DemoMacrosMacros", type: "StubMacro")
