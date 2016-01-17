//
//  NSURL+Preview.swift
//  NSURL-Validation-Demo
//
//  Created by James Hickman on 11/20/14.
//  Copyright (c) 2014 NitWit Studios. All rights reserved.
//

import Foundation

class HTMLParser {
    
    var xmlParser: NSXMLParser?
    var html : String?
    
    func initWithUrl(url: NSURL) {
        self.xmlParser = NSXMLParser(contentsOfURL: url)
    }
}
