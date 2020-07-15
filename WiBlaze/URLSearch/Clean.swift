//
//  Clean.swift
//  UWeb
//
//  Created by Justin Bush on 2020-07-08.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Clean {
    
    /// Cleans and reformats Optional URL string.
    /// `Optional("rawURL") -> rawURL`
    static func url(_ urlString: String) -> String {
        var url = urlString.replacingOccurrences(of: "Optional", with: "")
        let brackets: Set<Character> = ["(", ")"]
        url.removeAll(where: { brackets.contains($0) })
        return url
    }
    
}
