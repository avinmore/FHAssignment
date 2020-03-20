//
//  FHImagePreviewViewModel.swift
//  FHAssignment
//
//  Created by Avin on 20/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation
import UIKit

class FHImagePreviewViewModel {

    func downloadImage(_ imageURLString: String, complition: @escaping((UIImage?) -> Void)) {
        let imageWorker = FHImageWorker()
        imageWorker.fetchImage(stringURL: imageURLString) { (image) in
            complition(image)
        }
    }
}
