//
//  FHSearchResultModel.swift
//  FHAssignment
//
//  Created by Avin on 19/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation

struct FHSearchResultResponse: Codable {
    var value: [FHImageResult]
}

struct FHImageResult: Codable {
    var url: String
    var thumbnail: String
}
