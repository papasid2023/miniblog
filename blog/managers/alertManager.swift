//
//  alertManager.swift
//  blog
//
//  Created by Руслан Сидоренко on 20.04.2024.
//

import UIKit

class alertManager {
 
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?){
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

//MARK: validation alerts
extension alertManager {
    public static func showInvalidEmailAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Invalid email", message: "Guess you forgot enter some characters like @ or .")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Invalid password", message: "Password must contains a minimum one Uppercased letter, number and special character")
    }
    
    public static func showInvalidUsernameAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Invalid username", message: "Please enter your username")
    }
}

//MARK: registration alerts
extension alertManager {
    public static func showRegistrationErrorAler(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Unknown registation error", message: nil)
    }
}
