//
//  postFromUDViewController.swift
//  blog
//
//  Created by Руслан Сидоренко on 14.06.2024.
//

//MARK: Раздел дорабатывается
//import UIKit
//
//class postFromUDViewController: UITabBarController, UITableViewDataSource, UITableViewDelegate {
//    
//    private let post: newpostDefaults.userpostForDefaults
//    
//    init(post: newpostDefaults.userpostForDefaults) {
//        self.post = post
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private let tableView: UITableView = {
//        let table = UITableView()
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        table.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
//        
//        return table
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        view.addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//       
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1 // title, image, text
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let index = indexPath.row
//        switch index {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = post.title
//            cell.selectionStyle = .none
//            cell.textLabel?.numberOfLines = 0
//            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//            return cell
//        case 1:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier,
//                                                           for: indexPath) as? PostHeaderTableViewCell else {
//                fatalError()
//            }
//            cell.selectionStyle = .none
//            cell.configure(with: .init(imageUrl: post.headerImageUrl))
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = post.text
//            cell.selectionStyle = .none
//            cell.textLabel?.numberOfLines = 0
//            cell.textLabel?.lineBreakMode = .byWordWrapping
//            
//            return cell
//        default:
//            fatalError()
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let index = indexPath.row
//        switch index {
//        case 0:
//            return UITableView.automaticDimension
//        case 1:
//            return 200
//        case 2:
//            return UITableView.automaticDimension
//        default:
//            return UITableView.automaticDimension
//        }
//    }
//    
//
//
//}
