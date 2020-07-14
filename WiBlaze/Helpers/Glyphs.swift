//
//  Glyph.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-28.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit

struct Glyph {
    
    // Custom Glyphs
    static let menu = UIImage(named: "dots")
    
    // System Glyphs
    static let back = UIImage(systemName: "arrow.left")
    static let secure = UIImage(systemName: "lock.shield.fill")
    static let reload = UIImage(systemName: "arrow.clockwise")
    static let close = UIImage(systemName: "xmark.square")
    static let deleteBack = UIImage(systemName: "delete.left")
    
    //MARK:- Settings Glyphs
    
    // Dark Mode
    /*
    static let moonOFF = UIImage(systemName: "moon")
    static let moonON = UIImage(systemName: "moon.fill")
    static func getMoonIcon() -> UIImage {
        if Settings.darkMode { return moonON! }
        else { return moonOFF! }
    }
    */
    
}

struct GlyphColor {
    
    static let bw = UIColor.init(named: "BlackWhite")
    
}

