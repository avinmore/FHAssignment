//
//  FHImageWorker.swift
//  FHAssignment
//
//  Created by Avin on 20/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation
import UIKit

struct FHImageWorker {

    func fetchImage(stringURL: String, complition: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: stringURL) else {
            complition(nil)
            return
        }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    complition(image)
                } else {
                    print("Invalid image data for \(stringURL)")
                    complition(nil)
                }
            }  else {
                print("No image found for \(stringURL)")
                complition(nil)
            }
        }
    }
}

