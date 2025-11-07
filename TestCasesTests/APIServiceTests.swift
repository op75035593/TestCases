//
//  APIServiceTests.swift
//  TestCasesTests
//
//  Created by LAP1120 on 26/10/25.
//

import Foundation


import XCTest
@testable import TestCases   // Replace with your target/module name

final class APIServicegetTests: XCTestCase {
    
    var apiService: APIServiceget!
    
    override func setUp() {
        super.setUp()
        apiService = APIServiceget()  // Default valid URL
    }
    
    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    // ✅ Test for successful API call
    func testFetchUsers_Success() {
        let expectation = self.expectation(description: "Fetch Users Success")
        
        apiService.fetchUsers { result in
            switch result {
            case .success(let users):
                XCTAssertFalse(users.isEmpty, "User list should not be empty")
                XCTAssertNotNil(users.first?.name)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // ✅ Test for invalid URL
    func testFetchUsers_InvalidURL() {
        let invalidService = APIServiceget(urlString: "invalid_url")
        let expectation = self.expectation(description: "Invalid URL Test")
        
        invalidService.fetchUsers { result in
            switch result {
            case .success:
                XCTFail("Expected failure for invalid URL")
            case .failure(let error):
                XCTAssertNotNil(error, "Should return an error for invalid URL")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
