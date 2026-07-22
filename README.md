# talk-demo

What we will build

```swift
@Mock
protocol UserRepository {
    func fetchUser(id: String) async throws -> User
}

// This will be generated

class MockUserRepository: UserRepository {
    // Errors thrown when stubs are not set
    enum StubError: Error {
        case fetchUser
    }
    
    // Stubbing
    final class Stubs: @unchecked Sendable {
        var fetchUserResult: Result<User, any Error>?
    }
    
    let stubs = Stubs()
    
    // Spying
    
    struct Spy: Sendable {
        fileprivate let fetchUserTracker = MacroTypes._FunctionCallTracker<(String)>()
        
        var fetchUserCalls: [(String)] {
            fetchUserTracker.calls
        }
    }
    
    let spy = Spy()
    
    // initializer
    
    init() {}
    
    // conformance
    
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
}
```

So let's break it down to the different parts we want to build.

We need a peer macro where the generated type will be prefixed by Mock.

1. StubError enum to contain unique errors per function in the protocol
2. Stub struct to be able to store a result for what it should do when the function is called. Along with the instance
3. Spy to store every call of the function for parameter tracking
4. Empty initializer
5. Actually adding a conformance to the protocol.
