//
//  Colors.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 2/21/19.
//  Copyright © 2019 Smile App Development. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    struct Custom {
        static let Orange = UIColor(red: 186, green: 45, blue: 11)
        static let Gunmetal = UIColor(red: 42, green: 45, blue: 52)
        static let RussianGreen = UIColor(red: 92, green: 148, blue: 110)
        static let CambridgeBlue = UIColor(red: 128, green: 194, blue: 175)
        static let LightGray = UIColor(red: 215, green: 205, blue: 204)
    }
}
