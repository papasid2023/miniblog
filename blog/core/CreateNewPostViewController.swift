//
//  CreateNewPostViewController.swift
//  blog
//
//  Created by Руслан Сидоренко on 26.04.2024.
//

import UIKit
import FirebaseAuth
import CoreData

class CreateNewPostViewController: UIViewController {

    private let headerImageView = UIImageView()
    private let postTitle = customCreatePostTextField(postCustomCreatePostTextFieldType: .title)
    private let postText = customCreatePostTextField(postCustomCreatePostTextFieldType: .text)
    private var selectedHeaderImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        postTitle.becomeFirstResponder()
        configureButtons()
        setupUI()
        hideKeyboardWhenTappedAround()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
        
    }

    private func setupUI(){
        
        view.addSubview(headerImageView)
        view.addSubview(postTitle)
        view.addSubview(postText)
        
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.isUserInteractionEnabled = true
        headerImageView.backgroundColor = .opaqueSeparator
        headerImageView.tintColor = .white
        headerImageView.clipsToBounds = true
        headerImageView.layer.cornerRadius = 12
        headerImageView.image = UIImage(systemName: "photo.badge.plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 2, weight: .medium))
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        postTitle.translatesAutoresizingMaskIntoConstraints = false
        postText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            headerImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            headerImageView.heightAnchor.constraint(equalToConstant: 200),
            
            postTitle.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 20),
            postTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            postTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            postTitle.heightAnchor.constraint(equalToConstant: 50),
            
            postText.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 10),
            postText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            postText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            postText.heightAnchor.constraint(equalToConstant: 100)
            
        ])
        
    }
    
    private func configureButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    @objc func didTapHeader(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapPost(){
        
        // check data
        guard let title = postTitle.text,
              let body = postText.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email") else {
            let alert = UIAlertController(title: "Enter post details", message: "Please enter a title, text and select an image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        print("Starting post...")
        
        let newPostId = UUID().uuidString
        
        
        //upload header image
        storageManager.shared.uploadBlogHeaderImage(
            email: email,
            image: headerImage,
            postId: newPostId
        ) { success in
            guard success else {
                return
            }
            storageManager.shared.downloadUrlForBlogHeaderImage(email: email, postId: newPostId) { url in
                guard let headerUrl = url else {
                    print("Failed to upload url for Header")
                    return
            }
                
                let dateFormatter = DateFormatter()
                let date = Date()
                dateFormatter.dateFormat = "dd MMMM yyyy hh:mm:ss"
                dateFormatter.locale = Locale(identifier: "ru_RU")
                let convertedDate: String = dateFormatter.string(from: date)
                
                let post = blogpost(identifier: newPostId,
                                    title: title,
                                    timestamp: convertedDate,
                                    headerImageUrl: headerUrl,
                                    text: body
                )
                
                
                
                //MARK: add data of new post in Firebase Firestore
                databaseManager.shared.insert(blogBost: post, email: email) { [weak self] posted in
                    print("Success to create a new blog post")
                    guard posted else {
                        print("Failed to post a new blog article")
                        return
                    }
                    DispatchQueue.main.async {
                        print("Posted new post notification")
                        NotificationCenter.default.post(name: .didCreateNewPost, object: nil)
                        self?.didTapCancel()
                    }
                }
                
                //MARK: add data of new post in UserDefaults
                //MARK: раздел дорабатывается
//                print("add post in UserDefaults...")
//                newpostDefaults.shared.saveUserPost(identifier: post.identifier,
//                                                    title: post.title,
//                                                    timestamp: post.timestamp,
//                                                    headerImageUrl: post.headerImageUrl,
//                                                    text: post.text)
            }
            
            
        }
        
            
    }
    
}

extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        selectedHeaderImage = image
        headerImageView.image = image
    }
}

extension Notification.Name {
    static let didCreateNewPost = Notification.Name("didCreateNewPost")
}
