//
//  FeedTableViewCell.swift
//  AC3.2-Final
//
//  Created by Jermaine Kelly on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseStorage

class FeedTableViewCell: UITableViewCell {
    static let cellIdentifer: String = "feedCell"
    var post: Post!{
        didSet{
            setUpCellViews()
        }
    }
    
    private func setUpCellViews(){
        
        self.addSubview(cellImageView)
        self.addSubview(commentLabel)
        self.selectionStyle = .none
        self.backgroundColor = .white
        
        cellImageView.snp.makeConstraints { (view) in
            view.top.leading.trailing.equalToSuperview()
            view.height.equalTo(self.snp.width)
        }
        
        commentLabel.snp.makeConstraints { (view) in
            view.top.equalTo(self.cellImageView.snp.bottom).offset(10)
            view.leading.equalToSuperview().offset(10)
            view.trailing.bottom.equalToSuperview().inset(10)
        }
    
        setUpCell()
    }
    
    private func setUpCell(){
        
        commentLabel.text = post.comment
        cellImageView.image = nil
        let storageRef = FIRStorage.storage().reference(forURL: "gs://ac-32-final.appspot.com")
        let imageRef = storageRef.child("images/\(post.key)")
        
        imageRef.data(withMaxSize: 1 * 1024 * 1024 ) { (data: Data?, error: Error?) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let data = data{
                if let image = UIImage(data: data){
                    self.cellImageView.alpha = 0
                    DispatchQueue.main.async {
                        self.cellImageView.image = image
                    }
                    UIView.animate(withDuration: 0.5, animations: {
                        self.cellImageView.alpha = 1
                    })
                }
            }
        }
    }
    
    private let commentLabel : UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.text = "Comments..."
        return label
    }()
    
    private let cellImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "imagePlaceholder")
        return imageView
    }()
    
}
