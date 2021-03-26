//
//  SignInLogic.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation
import Combine

protocol SignInLogicProtocol {
    func signIn(
        with credentials: (user: String?, password: String?)
    ) -> AnyPublisher<Session, SessionManager.SignInError>
}

class SignInLogic: SignInLogicProtocol {
    let sessionManager = SessionManager()
    
    func signIn(
        with credentials: (user: String?, password: String?)
    ) -> AnyPublisher<Session, SessionManager.SignInError> {
        guard let validCredentials = areCredentialsValid(
            user: credentials.user,
            password: credentials.password
        ) else {
            return Fail<Session, SessionManager.SignInError>(
                error: .credentialsAreInvalid
            ).eraseToAnyPublisher()
        }
        return sessionManager.signIn(with: validCredentials)
    }
    
    /// Pre-validate credentials that would produce an error response from backend
    func areCredentialsValid(
        user: String?,
        password: String?
    ) -> (user: String, password: String)? {
        guard let user = user, let password = password else {
            return nil
        }
        
        guard
            user.trimmingCharacters(in: .whitespacesAndNewlines) != "",
            password.trimmingCharacters(in: .whitespacesAndNewlines) != ""
        else {
            return nil
        }
        
        return (user: user, password: password)
    }
}
