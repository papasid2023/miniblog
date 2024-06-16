//
//  CreateNewPostSecondViewController.swift
//  blog
//
//  Created by Руслан Сидоренко on 02.05.2024.
//

import UIKit

class CreateNewPostSecondViewController: UIViewController {

    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        setupItems()
        
        imagePicker.sourceType = .camera
        imagePicker.startVideoCapture()
        
        
    }
    
    private func setupItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(didTapCancel))
    }
    
    @objc func didTapCancel(){
        dismiss(animated: true)
    }
    

}


