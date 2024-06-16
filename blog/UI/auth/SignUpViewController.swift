//
//  SignUpViewController.swift
//  blog
//
//  Created by Руслан Сидоренко on 20.04.2024.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let usernameField = customTextField(authCustomTextFieldType: .username)
    private let emailField = customTextField(authCustomTextFieldType: .email)
    private let passwordField = customTextField(authCustomTextFieldType: .password)
    private let registerButton = customButton(authCustomButtomType: .register)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign Up"
        view.backgroundColor = .systemBackground
        
        setupUI()
        usernameField.becomeFirstResponder()
        hideKeyboardWhenTappedAround()
        
        registerButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }
    
    private func setupUI(){
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        
        
        NSLayoutConstraint.activate([
            usernameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.midY - 200),
            usernameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            usernameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            usernameField.heightAnchor.constraint(equalToConstant: 35),
            
            emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 5),
            emailField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            emailField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            emailField.heightAnchor.constraint(equalToConstant: 35),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 5),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            passwordField.heightAnchor.constraint(equalToConstant: 35),
            
            registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func didTapBack(){
        dismiss(animated: true)
    }
    
    @objc func didTapCreateAccount(){
        
        let registerRequest = registerUserRequest(username: usernameField.text ?? "", email: emailField.text ?? "", password: passwordField.text ?? "")
        
        if !validationManager.isValidUsername(for: registerRequest.username) {
            alertManager.showInvalidUsernameAlert(on: self)
            return
        }
        if !validationManager.isValidEmail(for: registerRequest.email) {
            alertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        if !validationManager.isValidPassword(for: registerRequest.password) {
            alertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        authManager.shared.createAccount(with: registerRequest) { [weak self] success in
            if success {
                //update database
                let newUser = user(email: registerRequest.email, username: registerRequest.username, profilePicRef: nil)
                databaseManager.shared.insert(user: newUser) { inserted in
                    guard inserted else {
                        return
                    }
                    UserDefaults.standard.set(registerRequest.email, forKey: "email")
                    UserDefaults.standard.set(registerRequest.username, forKey: "name")
                    
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            } else {
                print("Failed to create account")
            }
        }
    }
}
