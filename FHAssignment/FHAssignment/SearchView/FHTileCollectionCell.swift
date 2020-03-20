//
//  FHTileCollectionCell.swift
//  FHAssignment
//
//  Created by Avin on 19/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation
import UIKit

class FHTileCollectionCell: UICollectionViewCell {
        
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var viewModel = FHTileCollectionCellViewModel()
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.backgroundColor = UIColor.lightText.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }
    
    func setupCell(data: FHImageResult, completion: @escaping ((UIImage?) -> Void)) {
        activityIndicator.startAnimating()
        viewModel.downloadImageFor(thumbnail: data.thumbnail) { [weak self] (image) in
            completion(image ?? UIImage(named: "no_photo"))
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
