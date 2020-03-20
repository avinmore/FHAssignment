//
//  FHDatabaseWorker.swift
//  FHAssignment
//
//  Created by Avin on 19/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FHDatabaseWorker {
    
    func fetchImages(with query: String, page: Int) -> [FHImageResult]? {
        guard let context  = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageData")
        request.predicate = NSPredicate(format: "query = %@ AND page = %@", argumentArray:  [query, page])
        do {
            let result = try context.fetch(request)
            let images = result.compactMap({ image -> FHImageResult? in
                if let imageData = image as? ImageData,
                    let url = imageData.imageUrl,
                    let thum = imageData.thumbnail {
                    return FHImageResult(url: url, thumbnail: thum)
                }
                return nil
            })
            return images
        } catch {
            print("Failed to fetch")
            return nil
        }
    }
    
    func saveImageResponse(_ imageData: [FHImageResult], page: Int, query: String) {
        guard !imageData.isEmpty else { return }
        DispatchQueue.main.async {
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
            let _ = imageData.map({ image -> Void in
                let entity = NSEntityDescription.entity(forEntityName: "ImageData", in: context)
                let object = NSManagedObject.init(entity: entity!, insertInto: context)
                object.setValue(image.url, forKey: "imageUrl")
                object.setValue(image.thumbnail, forKey: "thumbnail")
                object.setValue(page, forKey: "page")
                object.setValue(query, forKey: "query")
            })
            do {
                try context.save()
                print("Saved")
            } catch {
                print("Failed to saved")
            }
        }        
    }
    
    func updateThumbnail(thumbnailURLString: String, image: UIImage?) {
        guard let dataToSave = image?.jpegData(compressionQuality: 1.0) else {
            return
        }
        DispatchQueue.main.async {
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageData")
            request.predicate = NSPredicate(format: "thumbnail = %@", argumentArray:  [thumbnailURLString])
            do {
                let result = try context.fetch(request)
                if let object = result.first as? NSManagedObject {
                    object.setValue(dataToSave, forKey: "thumbnailImage")
                }
            } catch {
                print("Failed to fetch")
            }
        }
    }
    
    func fetchThumbnail(thumbnailURLString: String) -> UIImage? {
        guard let context  = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return nil
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageData")
        request.predicate = NSPredicate(format: "thumbnail = %@", argumentArray:  [thumbnailURLString])
        do {
            let result = try context.fetch(request)
            if let object = result.first as? ImageData, let data = object.thumbnailImage as? Data {
                return UIImage(data: data)
            }
            return nil
        } catch {
            print("Failed to fetch")
            return nil
        }
    }
}
