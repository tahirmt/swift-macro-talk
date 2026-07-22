import DemoMacros

import struct os.OSAllocatedUnfairLock

@Stub
struct User {
    let name: String
    let age: Int
}

@Mock
protocol UserRepository {
    func fetchUser(id: String) async throws -> User
}

let mock = MockUserRepository()
mock.stubs.fetchUserResult = .success(.stub(name: "Alice", age: 30))

let user = try await mock.fetchUser(id: "")

print(user)
