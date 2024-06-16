//
//  customTextField.swift
//  blog
//
//  Created by Руслан Сидоренко on 20.04.2024.
//

import UIKit

class customTextField: UITextField {
    
    enum customTextFieldType {
        case username
        case email
        case password
    }
    
    private let authCustomTextFieldType: customTextFieldType
    
    init(authCustomTextFieldType: customTextFieldType) {
        self.authCustomTextFieldType = authCustomTextFieldType
        super.init(frame: .zero)
        
        layer.borderWidth = 1
        layer.cornerRadius = 12
        layer.borderColor = UIColor.black.cgColor
        autocorrectionType = .no
        autocapitalizationType = .none
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        leftView = UIView(frame: .init(x: 0, y: 0, width: 15, height: 0))
        leftViewMode = .always
        
        switch authCustomTextFieldType {
        case .username:
            placeholder = "Enter your username"
        case .email:
            placeholder = "Email"
            keyboardType = .emailAddress
        case .password:
            placeholder = "Password"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
