//
//  UsersViewModelTests.swift
//  TestCasesTests
//
//  Created by LAP1120 on 16/10/25.
//

import Foundation

import XCTest
@testable import TestCases  // Replace MyApp with your project/module name



final class MockAPIService: APIServiceProtocol {
    var shouldThrowError = false
    
    func fetchUsers() async throws -> [User] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return [
            User(id: 1, name: "Alice"),
            User(id: 2, name: "Bob")
        ]
    }
}

@MainActor
final class UsersViewModelTests: XCTestCase {
    
    func testLoadUsers_Success() async throws {
        let mockService = MockAPIService()
        let viewModel = UsersViewModel(apiService: mockService)
        
        await viewModel.loadUsers()
        
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadUsers_Failure() async throws {
        let mockService = MockAPIService()
        mockService.shouldThrowError = true
        let viewModel = UsersViewModel(apiService: mockService)
        
        await viewModel.loadUsers()
        
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}





import Foundation
import XCTest

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Handler is unavailable.")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}



import XCTest
@testable import TestCases

final class APIServicepostTests: XCTestCase {

    var apiService: APIServicepost!
    var session: URLSession!

    override func setUp() {
        super.setUp()

        // Configure URLSession with mock protocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        apiService = APIServicepost(session: session)
    }

    override func tearDown() {
        apiService = nil
        session = nil
        super.tearDown()
    }

    // ✅ Test Success Scenario
    func testCreateUser_Success() async throws {
        // Given
        let testUser = Userpost(id: nil, name: "John", email: "john@example.com")
        let mockResponseUser = Userpost(id: 1, name: "John", email: "john@example.com")
        let mockData = try JSONEncoder().encode(mockResponseUser)

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertTrue(request.url?.absoluteString.contains("/users") ?? false)
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockData)
        }

        // When
        let createdUser = try await apiService.createUser(testUser)

        // Then
        XCTAssertEqual(createdUser.id, 1)
        XCTAssertEqual(createdUser.name, "John")
        XCTAssertEqual(createdUser.email, "john@example.com")
    }

    // ❌ Test Failure (bad status code)
    func testCreateUser_Failure_BadResponse() async throws {
        let testUser = Userpost(id: nil, name: "Jane", email: "jane@example.com")
        let mockData = Data()

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockData)
        }

        do {
            _ = try await apiService.createUser(testUser)
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            // Expected failure
            XCTAssertTrue(error is URLError)
        }
    }
}
