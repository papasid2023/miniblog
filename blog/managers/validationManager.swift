//
//  validationManager.swift
//  blog
//
//  Created by Руслан Сидоренко on 20.04.2024.
//

import Foundation

struct validationManager {
    
    static func isValidEmail(for email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[ A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidPassword(for password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{6,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    static func isValidUsername(for username: String) -> Bool {
        let usernameRegEx = "\\w{4,24}"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        return usernamePred.evaluate(with: username)
    }
    
}
