//
//  LoginTest.swift
//  TheMovieDBTests
//
//  Created by Jhonatan A. on 25/03/21.
//

import XCTest
@testable import TheMovieDB

class LoginTest: XCTestCase {
    func testValidCredentials() throws {
        let sessionManager = SessionManager()
        
        // Can login with known valid credentials
        let validCredentials = (user: "Admin", password: "Password*123")
        do {
            let result = try await(sessionManager.signIn(with: validCredentials))
            XCTAssertEqual(result, Session())
        } catch {
            XCTFail()
        }
    }
    
    func testInvalidCredentials() throws {
        let sessionManager = SessionManager()
        
        // Can't login with known invalid credentials
        let invalidCredentials = (user: "!", password: "!")
        do {
            _ = try await(sessionManager.signIn(with: invalidCredentials))
            XCTFail()
        } catch SessionManager.Error.userNotRegistered {
        } catch {
            XCTFail()
        }
    }
    
    func testEmptyCredentials() throws {
        let sessionManager = SessionManager()
        
        // Can't login with known invalid credentials
        let invalidCredentials = (user: "", password: "")
        do {
            _ = try await(sessionManager.signIn(with: invalidCredentials))
            XCTFail()
        } catch SessionManager.Error.userNotRegistered {
        } catch {
            XCTFail()
        }
    }
}
