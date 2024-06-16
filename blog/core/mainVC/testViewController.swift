//
//  testViewController.swift
//  blog
//
//  Created by Руслан Сидоренко on 14.06.2024.
//
//MARK: раздел дорабатывается
//import UIKit
//
//class testViewController: UIViewController {
//
//    let tableView = UITableView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNewPostNotification), name: .didCreateNewPost, object: nil)
//    }
//    
//    var userPosts: [newpostDefaults.userpostForDefaults] = newpostDefaults.shared.userposts
//    
//    private func setupTableView(){
//        
//        view.addSubview(tableView)
//        tableView.frame = view.bounds
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
//    }
//    
//    @objc private func didReceiveNewPostNotification() {
//        
//        DispatchQueue.main.async {
//            print("Received new post notification")
//            newpostDefaults.shared.userposts
//            self.tableView.reloadData()
//        }
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: .didCreateNewPost, object: nil)
//    }
//
//
//}
//
//extension testViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return newpostDefaults.shared.userposts.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let posts = newpostDefaults.shared.userposts[indexPath.row]
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
//            fatalError()
//        }
//        cell.configure(with: .init(title: posts.title,
//                                   imageUrl: posts.headerImageUrl,
//                                   created: posts.timestamp))
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let vc = postFromUDViewController(post: userPosts[indexPath.row])
//        
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//    
//    
//}
