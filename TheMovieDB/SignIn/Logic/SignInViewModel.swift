//
//  SignInViewModel.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import Foundation
import Combine

protocol SignInViewModelProtocol {
    func signIn(withUser username: String?, password: String?) -> AnyPublisher<Session, SessionManager.SignInError>
}

class SignInViewModel: SignInViewModelProtocol {
    let logic = SignInLogic()
    
    func signIn(withUser username: String?, password: String?) -> AnyPublisher<Session, SessionManager.SignInError> {
        logic.signIn(with: (user: username, password: password))
    }
}
