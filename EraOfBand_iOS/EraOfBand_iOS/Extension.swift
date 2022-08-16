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

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
}
