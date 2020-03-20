//
//  FHAPIWorker.swift
//  FHAssignment
//
//  Created by Avin on 19/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation

enum ErrorDetails: Error {
    case responseNotReceived
    case failed
}

struct FHAPIWorker {
    enum Constant {
        static let APIKey = "172f6200e7msh0d901ba7e967555p18503ajsn97baf0364002"
        static let APIHost = "contextualwebsearch-websearch-v1.p.rapidapi.com"
        static let ImageSearchAPI = "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/ImageSearchAPI"
    }
    
    func fetchImageList(_ query: FHSerachQuery,
                        completion:@escaping (Result<[FHImageResult], ErrorDetails>) ->Void) {
        
        guard var apiURL = URLComponents(string: Constant.ImageSearchAPI) else {
            completion(.failure(.failed))
            return
        }
        var items = [URLQueryItem]()
        for (key,value) in query.queryParams() {
            items.append(URLQueryItem(name: key, value: value))
        }
        apiURL.queryItems = items
        
        guard let requesrURL = apiURL.url else {
            completion(.failure(.failed))
            return
        }
        
        var request = URLRequest(url: requesrURL)
        request.setValue(Constant.APIKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(Constant.APIHost, forHTTPHeaderField: "x-rapidapi-host")
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let jsonResponse = data, jsonResponse.count > 0 else {
                completion(.failure(.responseNotReceived))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(FHSearchResultResponse.self, from: jsonResponse)
                let imageResult = response.value
                completion(.success(imageResult))
            } catch {
                completion(.failure(.failed))
            }
        }
        task.resume()
    }
}
