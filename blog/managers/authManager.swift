//
//  authManager.swift
//  blog
//
//  Created by Руслан Сидоренко on 20.04.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class authManager {
    
    public static let shared = authManager()
    
    public let auth = Auth.auth()
    init(){}
    
    //MARK: Create account in firebase
    public func createAccount(with registerRequest: registerUserRequest, completion: @escaping (Bool)-> Void){
        
        let username = registerRequest.username
        let email = registerRequest.email
        let password  = registerRequest.password
        
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error {
                completion(false)
                print("\(error). Failed to create a user \(username) with \(registerRequest.email).")
                return
            } else {
                completion(true)
                print("success to create a user \(registerRequest.email)")
                return
            }
        }
    }
        
    //MARK: Sign In account in firebase
    public func loginAccount(with loginRequest: loginUserRequest, completion: @escaping (Error?)-> Void){
        Auth.auth().signIn(withEmail: loginRequest.email, password: loginRequest.password) { result, error in
            if let error {
                completion(error)
                print("failed to login a user \(loginRequest.email)")
                return
            } else {
                completion(nil)
                print("success to login a user \(loginRequest.email)")
            }
        }
    }
    
    //MARK: Sign out 
    public func signOut(completion: @escaping (Error?)-> Void){
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
}
