//
//  FacialExpression.swift
//  faceIt
//
//  Created by JiaShu Huang on 2019/3/5.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import Foundation

struct FacialExpression {
    
    enum Eyes:Int {
        case open
        case closed
        case squinting
    }
    
    enum Mouth:Int {
        case frown
        case smrik
        case neutral
        case grin
        case smile
        
        var sadder:Mouth{
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        
        var happier:Mouth{
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
        
    }
    
    
    var sadder:FacialExpression {
        return FacialExpression(eyes:self.eyes,mouth:self.mouth.sadder)
    }
    
    var happier:FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
    
    let eyes:Eyes
    let mouth:Mouth
    
}
