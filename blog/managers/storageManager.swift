//
//  storageManager.swift
//  blog
//
//  Created by Руслан Сидоренко on 22.04.2024.
//

import UIKit
import Foundation
import FirebaseStorage

class storageManager {
    
    public static let shared = storageManager()
    
    private let container = Storage.storage()
    
    private init () {}
    
    public func uploadUserProfilePic(email: String,
                                     image: UIImage?,
                                     completion: @escaping (Bool)-> Void
    ){
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        guard let pngData = image?.jpegData(compressionQuality: 0.1) else {
            return
        }
        container.reference(withPath: "profile_pictures/\(path)/photo.jpeg").putData(pngData, metadata: nil) { metadata, error in
            guard metadata != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
            
        }
    }
    
    public func downloadUrlForProfilePicture(
           path: String,
           completion: @escaping (URL?) -> Void
       ) {
           container.reference(withPath: path)
               .downloadURL { url, _ in
                   completion(url)
               }
       }
    
    public func uploadBlogHeaderImage (email: String,
                                       image: UIImage,
                                       postId: String,
                                       completion: @escaping (Bool)-> Void
    ){
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        guard let pngData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        container
            .reference(withPath: "posts_headers/\(path)/\(postId).jpeg")
            .putData(pngData, metadata: nil) { metadata, error in
            guard metadata != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
            
        }
    }
    
    public func downloadUrlForBlogHeaderImage(email: String,
                                              postId: String,
                                              completion: @escaping (URL?)-> Void
    ){
        let emailComponent = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        container
            .reference(withPath: "posts_headers/\(emailComponent)/\(postId).jpeg")
            .downloadURL { url, _ in
                completion(url)
            }
            
        }
    }
