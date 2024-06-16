//
//  ProfileViewController.swift
//  blog
//
//  Created by Руслан Сидоренко on 20.04.2024.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let addContent = UIButton()
    private var user: user?
    var tableView = UITableView()
    let currentEmail: String
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy hh:mm:ss"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSignOut()
        setupTableView()
        setupAddContentButton()
        fetchPosts()
        title = currentEmail
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNewPostNotification), name: .didCreateNewPost, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc private func didReceiveNewPostNotification() {
        DispatchQueue.main.async {
            print("Received new post notification")
            self.fetchPosts()
            self.tableView.reloadData()
        }
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self, name: .didCreateNewPost, object: nil)
        }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        setupTableHeader()
        fetchProfileData()
    }
    
    private func setupTableHeader(
        profilePicRef: String? = nil,
        username: String? = nil
    ){
        let headerView = UIView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 200))
        headerView.isUserInteractionEnabled = true
        headerView.backgroundColor = .systemGroupedBackground
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        headerView.addGestureRecognizer(tap)
        
        
        //profile user picture
        let profilePic = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePic.tintColor = .white
        profilePic.isUserInteractionEnabled = true
        profilePic.clipsToBounds = true
        profilePic.contentMode = .scaleAspectFill
        profilePic.frame = .init(x: headerView.frame.midX-50,
                                 y: headerView.frame.midY-50,
                                 width: 100,
                                 height: 100)
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        headerView.addSubview(profilePic)
        
        
        
        //email label of user
        let emailLabel = UILabel(frame: .init(x: 18, y: profilePic.frame.maxY + 10, width: view.frame.width - 40, height: 20))
        headerView.addSubview(emailLabel)
        emailLabel.text = currentEmail
        emailLabel.textColor = .darkGray
        emailLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        emailLabel.textAlignment = .center
        
        
        //offer label of user
        let offerLabel = UILabel(frame: .init(x: 18, y: profilePic.frame.maxY + 10, width: view.frame.width - 40, height: 50))
        headerView.addSubview(offerLabel)
        offerLabel.text = "Tap to download Avatar"
        offerLabel.textColor = .darkGray
        offerLabel.textAlignment = .center
        offerLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        
        if let username = username {
            title = "Hello dear , " + username
        }
        
        //fetch image
        if let ref = profilePicRef {
            
            let activity = UIActivityIndicatorView()
            headerView.addSubview(activity)
            activity.center = headerView.center
            activity.startAnimating()
            
            storageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        profilePic.image = UIImage(data: data)
                    }
                }
                task.resume()
                activity.stopAnimating()
                
            }
        }
    }
    
    private func setupAddContentButton(){
        view.addSubview(addContent)
        addContent.translatesAutoresizingMaskIntoConstraints = false
        addContent.clipsToBounds = true
        addContent.layer.cornerRadius = 40
        addContent.backgroundColor = .blue
        addContent.tintColor = .white
        addContent.layer.shadowColor = UIColor.black.cgColor
        addContent.layer.shadowOpacity = 0.5
        addContent.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addContent.addTarget(self, action: #selector(didTapAddContent), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            addContent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            addContent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
            addContent.widthAnchor.constraint(equalToConstant: 80),
            addContent.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc func didTapProfilePic(){
        
        guard let myEmail = UserDefaults.standard.string(forKey: "email"), myEmail == currentEmail else {
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func didTapAddContent(){
        
        guard let myEmail = UserDefaults.standard.string(forKey: "email"), myEmail == currentEmail else {
            return
        }
        
        let vc = CreateNewPostViewController()
        vc.title = "create new post"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .formSheet
        present(navVC, animated: true)
        
    }
    
    private func fetchProfileData(){
        
        databaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user
            
            DispatchQueue.main.async {
                self?.setupTableHeader(
                    profilePicRef: user.profilePicRef,
                    username: user.username)
            }
        }        
    }
    
    private func setupSignOut(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
    }
    
    @objc func didTapLogout(){
        
        let sheet = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            authManager.shared.signOut { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                    return
                }
                UserDefaults.standard.set(nil, forKey: "email")
                UserDefaults.standard.set(nil, forKey: "username")
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
        }))
        present(sheet, animated: true)
    }
    
    //MARK: TableView
    
    public var  posts: [blogpost] = []
    
    private func fetchPosts(){
        
        print("Fetching posts...")
        
        let activity = UIActivityIndicatorView()
        view.addSubview(activity)
        activity.center = view.center
        activity.startAnimating()
        
        databaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
            self?.posts = posts
            self?.posts = posts.sorted(by: { first, second in
                guard let firstDate = self?.dateFormatter.date(from: first.timestamp),
                      let secondDate = self?.dateFormatter.date(from: second.timestamp) else {
                    return false
                }
                return firstDate > secondDate
            })
            
            print("Found \(posts.count) posts")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                activity.stopAnimating()
            }
        }
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title,
                                   imageUrl: post.headerImageUrl,
                                   created: post.timestamp))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.title = "post"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        storageManager.shared.uploadUserProfilePic(email: currentEmail, image: image) {
            [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                //update database
                databaseManager.shared.updateUserPic(email: strongSelf.currentEmail) { updated in
                    guard updated else {
                        return
                    }
                    DispatchQueue.main.async {
                        strongSelf.fetchProfileData()
                    }
                    print("success upload url for image")
                }
            }
            
        }
    }
    
}

