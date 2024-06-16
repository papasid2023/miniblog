//
//  ViewController.swift
//  blog
//
//  Created by Руслан Сидоренко on 20.04.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupBar()
    }
    
    private func setupBar(){
        
        tabBar.backgroundColor = .opaqueSeparator
        
        tabBar.isTranslucent = true
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.frame = tabBar.bounds
        tabBar.addSubview(blurView)
        
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else {
            return
        }
        
        let main = MainViewController()
        let profile = ProfileViewController(currentEmail: currentUserEmail)
        
        
        let nav1 = UINavigationController(rootViewController: main)
        let nav2 = UINavigationController(rootViewController: profile)
        
        nav1.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        
        
        setViewControllers([nav1, nav2], animated: true)
        
        for nav in [nav1, nav2] {
            nav.navigationBar.prefersLargeTitles = true
        }
    }


}

