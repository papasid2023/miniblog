//
//  newpostDefaults.swift
//  blog
//
//  Created by Руслан Сидоренко on 14.06.2024.
//

//MARK: Менеджер дорабатывается
//import Foundation
//
//class newpostDefaults {
//    
//    static let shared = newpostDefaults()
//    
//    let defaults = UserDefaults.standard
//    
//    struct userpostForDefaults:Codable {
//        let identifier: String
//        let title: String
//        let timestamp: String
//        let headerImageUrl: URL?
//        let text: String
//    }
//    
//    var userposts:[userpostForDefaults] {
//        
//        get {
//            if let data = defaults.value(forKey: "userposts") as? Data {
//                return try! PropertyListDecoder().decode([userpostForDefaults].self, from: data)
//            } else {
//                return [userpostForDefaults]()
//            }
//        }
//        
//        set {
//            if let data = try? PropertyListEncoder().encode(newValue) {
//                defaults.set(data, forKey: "userposts")
//            }
//        }
//        
//    }
//    
//    public func saveUserPost(identifier: String,
//                             title: String,
//                             timestamp: String,
//                             headerImageUrl: URL?,
//                             text: String
//    ){
//        let userPost = userpostForDefaults(identifier: identifier,
//                                       title: title,
//                                       timestamp: timestamp,
//                                       headerImageUrl: headerImageUrl,
//                                       text: text)
//        
//        userposts.insert(userPost, at: 0)
//    }
//    
//}
