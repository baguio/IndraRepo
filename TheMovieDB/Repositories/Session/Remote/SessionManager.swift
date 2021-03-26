//
//  File.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation
import Combine

class SessionManager {
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
                    result.send(Session())
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
    
    enum ContinuousSessionError: Swift.Error {
        case notAvailable
    }
}
