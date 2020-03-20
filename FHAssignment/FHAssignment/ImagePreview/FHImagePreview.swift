//
//  FHImagePreview.swift
//  FHAssignment
//
//  Created by Avin on 20/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation
import UIKit
class FHImagePreview: UIViewController {
    
    var imageURLString = ""
    @IBOutlet weak var imageView: UIImageView!
    var viewModel = FHImagePreviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.downloadImage(imageURLString) {image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
