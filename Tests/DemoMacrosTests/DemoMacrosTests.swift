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
                func helloSwiftRockies()
            }
            """
        } expansion: {
            """
            protocol UserRepository {
                func fetchUser(id: String) async throws -> User
                func helloSwiftRockies()
            }

            #if DEBUG
            final class MockUserRepository: UserRepository {
                enum StubError: Error {
                    case fetchUser
                    case helloSwiftRockies
                }
                init() {
                }
                final class Stubs: @unchecked Sendable {
                    /// The result to return for the method ``fetchUser``. If set to failure the given error will be thrown
                    var fetchUserResult: Result<User, any Error>?
                    /// The result to return for the method ``helloSwiftRockies``. If set to failure the given error will be thrown
                    var helloSwiftRockiesResult: Result<Void, any Error>?
                }
                /// Stubs allow you to stub out what the return value(s) of the mock will be.
                /// There is a stub value for each method and property.
                let stubs = Stubs()
                struct Spy: Sendable {
                    fileprivate let fetchUserTracker = MacroTypes._FunctionCallTracker<(String)>()

                    var fetchUserCalls: [(String)] {
                        fetchUserTracker.calls
                    }
                    fileprivate let helloSwiftRockiesTracker = MacroTypes._FunctionCallTracker<()>()

                    var helloSwiftRockiesCalls: [()] {
                        helloSwiftRockiesTracker.calls
                    }
                }
                let spy = Spy()
                    func fetchUser(id: String) async throws -> User {
                    spy.fetchUserTracker.called((id))
                    guard let result = stubs.fetchUserResult else {
                        throw StubError.fetchUser
                    }
                    switch result {
                    case .success(let value):
                        return value
                    case .failure(let error):
                        throw error
                    }
                }
                    func helloSwiftRockies() {
                    spy.helloSwiftRockiesTracker.called(())
                    guard let result = stubs.helloSwiftRockiesResult else {
                        fatalError("Does not throw but expected failure")
                    }
                    switch result {
                    case .success(let value):
                        return value
                    case .failure:
                        fatalError("Does not throw but expected failure")
                    }
                }
            }
            #endif
            """
        }
    }
}
#endif
