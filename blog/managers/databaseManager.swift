//
//  databaseManager.swift
//  blog
//
//  Created by Руслан Сидоренко on 21.04.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class databaseManager {
    
    public static let shared = databaseManager()
    
    private let database = Firestore.firestore()

    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy hh:mm:ss"
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
    
    init() {}
    
    public func insert(
        blogBost: blogpost,
        email: String,
        completion: @escaping (Bool)-> Void
    ){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data: [String : Any] = [
            "id": blogBost.identifier,
            "title": blogBost.title,
            "body": blogBost.text,
            "created": blogBost.timestamp,
            "headerImageUrl": blogBost.headerImageUrl?.absoluteString ?? ""
        ]
        
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .document(blogBost.identifier)
            .setData(data) { error in
                completion(error == nil)
            }
        }
    
    
    public func updateUserPic(
        email: String,
        completion: @escaping (Bool)-> Void
    ){
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        let photoReference = "profile_pictures/\(path)/photo.jpeg"
        
        let dbRef = database.collection("users").document(path)
        
        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            
            data["profile_photo"] = photoReference
            
            dbRef.setData(data) { error in
                completion(error == nil)
            }
        }
    }
    
    public func getAllposts(
        completion: @escaping ([blogpost])-> Void
    ){
        database
            .collection("users")
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }
                
                let emails: [String] = documents.compactMap({ return $0["email"] as? String })
                print(emails)
                
                guard !emails.isEmpty else {
                    completion([])
                    return
                }
                
                let group = DispatchGroup()
                var result: [blogpost] = []
                
                for email in emails {
                    group.enter()
                    self?.getPosts(for: email) { userposts in
                        defer {
                            group.leave()
                        }
                        result.append(contentsOf: userposts)
                    }
                }
                group.notify(queue: .global()) {
                    print("Feed posts: \(result.count)")
                    completion(result)
                }
        }
    }
    
    public func getPosts(
        for email: String,
        completion: @escaping ([blogpost])-> Void
    ){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                error == nil else {
                    return
                }
                
                let posts: [blogpost] = documents.compactMap({ dictionary in
                    guard let id = dictionary["id"] as? String,
                          let title = dictionary["title"] as? String,
                          let body = dictionary["body"] as? String,
                          let created = dictionary["created"] as? String,
                          let imageUrlString = dictionary["headerImageUrl"] as? String else {
                        print("Invalid post fetch conversion")
                        return nil
                    }
                    
                    let post = blogpost(identifier: id,
                                        title: title,
                                        timestamp: created,
                                        headerImageUrl: URL(string: imageUrlString),
                                        text: body)
                    return post
                })
                completion(posts)
            }
    }
    
    public func insert(
        user: user,
        completion: @escaping (Bool)-> Void
    ){
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data = [
            "email": user.email,
            "username": user.username
        ]
        
        //add data in db
        
        database
            .collection("users")
            .document(documentId)
            .setData(data) { error in
                completion(error == nil)
            }
        }
    
    public func getUser(
        email: String,
        completion: @escaping (user?)-> Void
    ) {
        let documentId = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        database
            .collection("users")
            .document(documentId)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data() as? [String: String],
                      let username = data["username"],
                        error == nil else {
                    return
                }
                
                let avatarRef = data["profile_photo"]
                
                let user = user(email: email, username: username, profilePicRef: avatarRef)
                completion(user)
            }
    }
    
    public func updatePostPic(
        email: String,
        completion: @escaping (Bool)-> Void
    ){
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        let photoReference = "post_pictures/\(path)/photo.png"
        
        let dbRef = database.collection("users").document(path)
        
        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            
            data["post_pic"] = photoReference
            
            dbRef.setData(data) { error in
                completion(error == nil)
            }
        }
    }
    
    public func uploadPost(
        user: user,
        blogpost: blogpost,
        completion: @escaping (Bool, Error?)-> Void
    ){
    
    }
    
    
}
