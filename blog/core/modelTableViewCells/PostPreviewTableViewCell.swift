//
//  PostPreviewTableViewCell.swift
//  blog
//
//  Created by Руслан Сидоренко on 30.04.2024.
//

import UIKit

class PostPreviewTableViewCellViewModel {
    let title: String
    let imageUrl: URL?
    var imageData: Data?
    let created: String
    
    init(title: String, imageUrl: URL?, created: String) {
        self.title = title
        self.imageUrl = imageUrl
        self.created = created
    }
}

class PostPreviewTableViewCell: UITableViewCell {
    
    static let identifier = "PostPreviewTableViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    
    private let postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let created:UILabel={
        let created=UILabel()
        created.numberOfLines = 0
        created.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return created
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
        contentView.addSubview(postTitleLabel)
        contentView.addSubview(created)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = CGRect(x: Int(separatorInset.left),
                                     y: 5,
                                     width: Int(contentView.frame.height-10),
                                     height: Int(contentView.frame.height-10))
        
        postTitleLabel.frame = CGRect(x: Int(postImageView.frame.maxX)+5,
                                      y: 5,
                                      width: Int(contentView.frame.width-5-separatorInset.left - postImageView.frame.width),
                                      height: Int(contentView.frame.height)-10)
        
        created.frame = CGRect(x: Int(postTitleLabel.frame.width - 150),
                               y: 5,
                               width: 200,
                               height: Int(contentView.frame.height)-10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text = nil
        postImageView.image = nil
        created.text = nil
        
    }
    
    func configure(with viewModel: PostPreviewTableViewCellViewModel){
        postTitleLabel.text = viewModel.title
        created.text = viewModel.created
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageUrl {
            //fetch image and cache
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
    
}
