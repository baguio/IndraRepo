//
//  SignInTest.swift
//  TheMovieDBTests
//
//  Created by Jhonatan A. on 26/03/21.
//

import XCTest
import Combine
@testable import TheMovieDB

class SignInTest: XCTestCase {
    private struct MockedLogic: SignInLogicProtocol {
        let signInSuccess: Bool
        
        func signIn(with credentials: (user: String?, password: String?)) -> AnyPublisher<Session, SessionManager.SignInError> {
            buildPublisher(
                success: signInSuccess,
                value: Session(),
                error: SessionManager.SignInError.credentialsAreInvalid
            )
        }
    }
    

    func testViewModel() throws {
        let viewModel = SignInViewModel()
        viewModel.logic = MockedLogic(
            signInSuccess: true
        )
        
        do {
            let data = try await(viewModel.signIn(withUser: nil, password: nil))
            XCTAssertEqual(data, Session())
        } catch {
            XCTFail()
        }
    }
}
