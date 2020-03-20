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
    var imageList = [FHImageResult]()
    
    //calllbacks
    var updateTableView: (() -> Void)?
    var networkActivity: ((Bool) -> Void)?
    var showError: ((String) -> Void)?
    
    func searchImage(for index: IndexPath) {
        //check in database
        let databaseWorker = FHDatabaseWorker()
        let page = (index.item / 10) + 1

        if let cachedImages = databaseWorker.fetchImages(with: queryString, page: page), !cachedImages.isEmpty {
            imageList.append(contentsOf: cachedImages)
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
                    self?.handleResponse(list: imageList, page: page)
                }
                self?.networkActivity?(false)
            }
        }
    }
    
    private func handleError(error: ErrorDetails) {
        switch error {
        case .responseNotReceived:
            showError?("No response from server")
        case .failed:
            showError?("Invalid response")
        }
    }
    
    private func handleResponse(list: [FHImageResult], page: Int) {
        let databaseWorker = FHDatabaseWorker()
        databaseWorker.saveImageResponse(imageList, page: page, query: queryString)
        imageList.append(contentsOf: list)
        updateTableView?()
    }
    
    func fetchNextPage(index: IndexPath) {
        guard (imageList.count - index.item) < 2 else {
            return
        }
        searchImage(for: IndexPath(item: index.item + 2, section: index.section))
    }
    
    func resetData() {
        imageList = [FHImageResult]()
    }
}
