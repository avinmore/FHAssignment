//
//  FHSerachQuery.swift
//  FHAssignment
//
//  Created by Avin on 19/03/20.
//  Copyright © 2020 avin. All rights reserved.
//

import Foundation

struct FHSerachQuery {
    //default
    var autoCorrect = false
    var pageNumber = 1
    var pageSize = 11
    var query = ""
    var safeSearch = false
    
    func queryParams() -> [String: String] {
        return ["autoCorrect": autoCorrect ? "true" : "false",
                "pageNumber":"\(pageNumber)",
                "pageSize":"\(pageSize)",
                "q":query,
                "safeSearch": safeSearch ? "true" : "false"]
    }
    
}
