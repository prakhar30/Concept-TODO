//
//  UIColorHelper.swift
//  Concept-TODO
//
//  Created by Prakhar Tripathi on 19/02/19.
//  Copyright © 2019 Prakhar Tripathi. All rights reserved.
//

import Foundation
import UIKit

class UIColorHelper {
    
    static func returnUIColouredViews(count: Int) -> [CAGradientLayer] {
        var sourceArray = [UIColor().fieryOrange(),
                           UIColor().blueOcean(),
                           UIColor().deepBlue(),
                           UIColor().maceWindu(),
                           UIColor().mojitoBlast(),
                           UIColor().lovelyPink(),
                           UIColor().haze(),
                           UIColor().beach(),
                           UIColor().metalic(),
                           UIColor().orangeMango()]
        var colouredView = [CAGradientLayer]()
        
        for _ in 0..<count {
            let randomIndex = Int.random(in: 0..<sourceArray.count)
            colouredView.append(sourceArray[randomIndex])
            sourceArray.remove(at: randomIndex)
        }
        return colouredView
    }
    
}
