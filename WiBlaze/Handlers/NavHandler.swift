//
//  NavHandler.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-05-05.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit
import Foundation

struct Nav {
    
    static var left = 0
    
    static func getLeftNavID() -> LeftNav {
        switch left {
        case 0: return LeftNav.back
        case 1: return LeftNav.secure
        case 2: return LeftNav.reload
        case 3: return LeftNav.close
        default: return LeftNav.back
        }
    }
    
}


enum LeftNav {
    case back
    case secure
    case reload
    case close
    
    var glyph: UIImage {
        switch self {
        case .back: return Glyph.back!
        case .secure: return Glyph.secure!
        case .reload: return Glyph.reload!
        case .close: return Glyph.close!
        }
    }
    
    var color: UIColor {
        switch self {
        case .back: return UIColor(named: "Primary")!
        case .secure: return UIColor(named: "Secure")!
        case .reload: return UIColor(named: "Primary")!
        case .close: return UIColor(named: "Primary")!
        }
    }
    
    var id: Int {
        switch self {
        case .back: return 0
        case .secure: return 1
        case .reload: return 2
        case .close: return 3
        }
    }
    
    var set: Int {
        switch self {
        case .back: Nav.left = 0; return 0
        case .secure: Nav.left = 1; return 1
        case .reload: Nav.left = 2; return 2
        case .close: Nav.left = 3; return 3
        }
    }
    
}
