import MacroTesting
import Testing

#if canImport(DemoMacrosMacros)
@testable import DemoMacrosMacros

@Suite(
    .macros(
        [
            "Mock": MockMacro.self
        ],
        record: .failed
    )
)
struct MacroTests {
    @Test
    func `mock expands correctly`() {
        assertMacro {
            """
            @Mock
            protocol UserRepository {
                func fetchUser(id: String) async throws -> User
            }
            """
        }
    }
}
#endif
