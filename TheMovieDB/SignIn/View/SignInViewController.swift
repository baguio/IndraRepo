//
//  ViewController.swift
//  AvalosJhonatan-TheMovieDB
//
//  Created by Jhonatan A. on 25/03/21.
//

import UIKit
import Combine

class SignInViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let model = SignInViewModel()
    
    var signInCancellable: AnyCancellable?

    @IBAction func signInActionTriggered(_ sender: Any) {
        signInCancellable = model.signIn(
            withUser: usernameTextField.text,
            password: passwordTextField.text
        ).sink { (completion) in
            if case .failure(let error) = completion {
                print("Error! \(error)")
                // TODO: UI error
            }
        } receiveValue: { (_) in
            self.dismiss(
                animated: true,
                completion: nil
            )
        }
    }
}
