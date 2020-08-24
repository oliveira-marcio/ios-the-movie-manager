//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        TMDBClient.getRequestToken(completion: handleRequestTokenResponse(success:error:))
    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLoggingIn(true)
        TMDBClient.getRequestToken() {
            (success, error) in
            print("Request token: \(TMDBClient.Auth.requestToken)")
            if success {
                UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            print("Request token: \(TMDBClient.Auth.requestToken)")
            TMDBClient.login(
                username: self.emailTextField.text ?? "",
                password: self.passwordTextField.text ?? "",
                completion: self.handleLoginResponse(success:error:)
            )
        } else {
            print("Error requesting token: \(error?.localizedDescription ?? "")")
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            print("Validated token: \(TMDBClient.Auth.requestToken)")
            TMDBClient.createSessionId(completion: handleSessionResponse(success:error:))
        } else {
            print("Authentication error: \(error?.localizedDescription ?? "")")
        }
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            print("Session ID: \(TMDBClient.Auth.sessionId)")
            self.performSegue(withIdentifier: "completeLogin", sender: nil)

        } else {
            print("Authentication error: \(error?.localizedDescription ?? "")")
        }
    }
    
    func setLoggingIn(_ logginingIn: Bool) {
        logginingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
