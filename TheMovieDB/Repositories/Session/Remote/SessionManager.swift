//
//  File.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation
import Combine

class SessionManager {
    private static var currentSession: Session?
    
    func obtainPersistedSession() -> AnyPublisher<Session, SessionManager.PersistedSessionError> {
        Just<Session?>(Self.currentSession)
            .mapError { $0 as Swift.Error }
            .tryMap {
                if let session = $0 {
                    return session
                } else {
                    throw SessionManager.PersistedSessionError.notAvailable
                }
            }
            .mapError { $0 as! SessionManager.PersistedSessionError }
            .eraseToAnyPublisher()
    }
    
    func signIn(
        with credentials: (user: String, password: String)
    ) -> AnyPublisher<Session, SessionManager.SignInError> {
        let result = PassthroughSubject<Session, SessionManager.SignInError>()
        
        defer {
            DispatchQueue.main.asyncAfter(
                // Simulating backend response time
                deadline: DispatchTime.init(uptimeNanoseconds: 2 * 1000 * 1000)
            ) {
                if credentials.user == "Admin",
                   credentials.password == "Password*123"
                {
                    let newSession = Session()
                    SessionManager.currentSession = newSession
                    result.send(newSession)
                    result.send(completion: .finished)
                } else {
                    result.send(completion: .failure(.userNotRegistered))
                }
            }
        }
        
        return result.eraseToAnyPublisher()
    }
    
    enum SignInError: Swift.Error {
        case userNotRegistered
        case credentialsAreInvalid
    }
    
    enum PersistedSessionError: Swift.Error {
        case notAvailable
    }
}
