//
//  MainViewController.swift
//  blog
//
//  Created by Руслан Сидоренко on 20.04.2024.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy hh:mm:ss"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    var posts: [blogpost] = []
    var filteredPosts: [blogpost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
        setupTableView()
        fetchAllPosts()
        title = "Feed"
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveNewPostNotification),
                                               name: .didCreateNewPost, object: nil)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search posts by title"
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc private func didReceiveNewPostNotification() {
        DispatchQueue.main.async {
            print("Received new post notification")
            self.fetchAllPosts()
            self.tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didCreateNewPost, object: nil)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchAllPosts() {
        print("Fetching home feed...")
        
        let activity = UIActivityIndicatorView()
        view.addSubview(activity)
        activity.center = view.center
        activity.startAnimating()
        
        databaseManager.shared.getAllposts { [weak self] posts in
            guard let self = self else { return }
            self.posts = posts.sorted(by: { first, second in
                guard let firstDate = self.dateFormatter.date(from: first.timestamp),
                      let secondDate = self.dateFormatter.date(from: second.timestamp) else {
                    return false
                }
                return firstDate > secondDate
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
                activity.stopAnimating()
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPosts.count
        }
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post: blogpost
        if isFiltering {
            post = filteredPosts[indexPath.row]
        } else {
            post = posts[indexPath.row]
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl, created: post.timestamp))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post: blogpost
        if isFiltering {
            post = filteredPosts[indexPath.row]
        } else {
            post = posts[indexPath.row]
        }
        
        let vc = ViewPostViewController(post: post)
        vc.title = "Post"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredPosts = posts.filter { (post: blogpost) -> Bool in
            return post.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}
