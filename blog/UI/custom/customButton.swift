//
//  customButton.swift
//  blog
//
//  Created by Руслан Сидоренко on 20.04.2024.
//

import UIKit

class customButton: UIButton {
    
    enum authCustomButton {
        case register
        case login
    }
    
    let authCustomButtomType: authCustomButton
    
    init(authCustomButtomType: authCustomButton) {
        self.authCustomButtomType = authCustomButtomType
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .orange
        titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        clipsToBounds = true
        layer.cornerRadius = 15
        titleLabel?.textColor = .white
        
        switch authCustomButtomType {
        case .register:
            setTitle("Create Account", for: .normal)
        case .login:
            setTitle("Login", for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
