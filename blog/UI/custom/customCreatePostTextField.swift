//
//  customCreatePostTextField.swift
//  blog
//
//  Created by Руслан Сидоренко on 26.04.2024.
//

import UIKit

class customCreatePostTextField: UITextField {

    enum customCreatePostTextFieldType {
        case title
        case text
    }
    
    private let postCustomCreatePostTextFieldType: customCreatePostTextFieldType
    
    init(postCustomCreatePostTextFieldType: customCreatePostTextFieldType) {
        self.postCustomCreatePostTextFieldType = postCustomCreatePostTextFieldType
        super.init(frame: .zero)
        
        layer.borderWidth = 1
        layer.cornerRadius = 12
        layer.borderColor = UIColor.opaqueSeparator.cgColor
        autocorrectionType = .yes
        autocapitalizationType = .none
        isUserInteractionEnabled = true
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        leftView = UIView(frame: .init(x: 0, y: 0, width: 15, height: 0))
        leftViewMode = .always
        
        switch postCustomCreatePostTextFieldType {
        case .title:
            placeholder = "Enter a title"
        case .text:
            placeholder = "Write some stuff"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
