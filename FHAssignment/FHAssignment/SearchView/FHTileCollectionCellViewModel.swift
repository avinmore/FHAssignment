//
//  FHTileCollectionCellViewModel.swift
//  FHAssignment
//
//  Created by Avin on 20/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation
import UIKit

class FHTileCollectionCellViewModel {
    
    func downloadImageFor(thumbnail: String, completion: @escaping ((UIImage?) -> Void)) {
        let databaseWorker = FHDatabaseWorker()
        if let image = databaseWorker.fetchThumbnail(thumbnailURLString: thumbnail) {
            completion(image)
        } else {
            let imageWorker = FHImageWorker()
            imageWorker.fetchImage(stringURL: thumbnail) { (image) in
                databaseWorker.updateThumbnail(thumbnailURLString: thumbnail, image: image)
                completion(image)
            }
        }
    }
}
