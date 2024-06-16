//
//  SignInViewController.swift
//  blog
//
//  Created by Руслан Сидоренко on 20.04.2024.
//

import UIKit

class SignInViewController: UIViewController {
    
    private let emailField = customTextField(authCustomTextFieldType: .email)
    private let passwordField = customTextField(authCustomTextFieldType: .password)
    private let loginButton = customButton(authCustomButtomType: .login)
    private let goToRegisterPage = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        setupUI()
        emailField.becomeFirstResponder()
        hideKeyboardWhenTappedAround()
        
        loginButton.addTarget(self, action: #selector(didTapLoginAccount), for: .touchUpInside)
        
    }
    
    private func setupUI(){
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(goToRegisterPage)
        
        goToRegisterPage.setTitle("Don't have account? Then register now", for: .normal)
        goToRegisterPage.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        goToRegisterPage.setTitleColor(.black, for: .normal)
        goToRegisterPage.titleLabel?.textAlignment = .center
        goToRegisterPage.translatesAutoresizingMaskIntoConstraints = false
        goToRegisterPage.addTarget(self, action: #selector(didTapGoToRegisterPage), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.midY - 200),
            emailField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            emailField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            emailField.heightAnchor.constraint(equalToConstant: 35),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 5),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            passwordField.heightAnchor.constraint(equalToConstant: 35),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            goToRegisterPage.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
            goToRegisterPage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            
            
        ])
    }
    
    @objc func didTapLoginAccount(){
        
        let loginRequest = loginUserRequest(email: emailField.text ?? "", password: passwordField.text ?? "")
        
        if !validationManager.isValidEmail(for: loginRequest.email) {
            alertManager.showInvalidEmailAlert(on: self)
        }
        
        if !validationManager.isValidPassword(for: loginRequest.password) {
            alertManager.showInvalidPasswordAlert(on: self)
        }
        
        authManager.shared.loginAccount(with: loginRequest) { error in
            if let error {
                print(error)
                return
            } else {
                UserDefaults.standard.set(loginRequest.email, forKey: "email")
                DispatchQueue.main.async {
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    @objc func didTapGoToRegisterPage(){
        print("tap")
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
}
