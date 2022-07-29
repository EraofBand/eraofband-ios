//
//  Extension.swift
//  EraOfBand_iOS
//
//  Created by 송재민 on 2022/07/29.
//

import UIKit

extension UIView {
    var x: CGFloat {
            get {
                self.frame.origin.x
            }
            set {
                self.frame.origin.x = newValue
            }
        }

        var y: CGFloat {
            get {
                self.frame.origin.y
            }
            set {
                self.frame.origin.y = newValue
            }
        }

        var height: CGFloat {
            get {
                self.frame.size.height
            }
            set {
                self.frame.size.height = newValue
            }
        }

        var width: CGFloat {
            get {
                self.frame.size.width
            }
            set {
                self.frame.size.width = newValue
            }
        }
}
