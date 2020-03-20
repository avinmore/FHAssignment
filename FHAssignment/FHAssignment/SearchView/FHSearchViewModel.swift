//
//  FHSearchViewModel.swift
//  FHAssignment
//
//  Created by Avin on 19/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation
import UIKit

class FHSearchViewModel {
    
    var queryString = ""
    var thumnails = [String]()
    var currentPage = 0
    var imageList = [FHImageResult]()
    
    //calllbacks
    var updateTableView: (() -> Void)?
    var networkActivity: ((Bool) -> Void)?
    var showError: ((String) -> Void)?
    
    func searchImage(for index: IndexPath) {
        //check in database
        let databaseWorker = FHDatabaseWorker()
        let page = (index.item / 10) + 1
        currentPage = page
        print("## Fetching data for page : \(page)")
        
        if let cachedImages = databaseWorker.fetchImages(with: queryString, page: page), !cachedImages.isEmpty {
            imageList.append(contentsOf: cachedImages)
            print("## DB count \(imageList.count)")
            updateTableView?()
        } else {
            //fetch from server
            networkActivity?(true)
            let worker = FHAPIWorker()
            var query = FHSerachQuery()
            query.query = queryString
            query.pageNumber = page
            worker.fetchImageList(query) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.handleError(error: error)
                    
                case .success(let imageList):
                    //Save to database
                    if let query = self?.queryString {
                        databaseWorker.saveImageResponse(imageList, page: page, query: query)
                        self?.imageList.append(contentsOf: imageList)
                        self?.updateTableView?()
                        print("## SERVER count \(self?.imageList.count ?? 0)")
                    }
                }
                self?.networkActivity?(false)
            }
        }
    }
    
    func handleError(error: ErrorDetails) {
        switch error {
        case .responseNotReceived:
            showError?("No response from server")
        case .failed:
            showError?("Invalid response")
        }
    }
    
    func fetchNextPage(index: IndexPath) {
        guard (imageList.count - index.item) < 2 else {
            return
        }
        searchImage(for: IndexPath(item: index.item + 2, section: index.section))
    }
    
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
    
    func resetData() {
        thumnails = [String]()
        currentPage = 0
        imageList = [FHImageResult]()
    }
}
