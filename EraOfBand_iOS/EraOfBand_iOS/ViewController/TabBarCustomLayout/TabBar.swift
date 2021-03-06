//
//  TabBarViewController.swift
//  EraOfBand_iOS
//
//  Created by 김영현 on 2022/07/04.
//

import UIKit


@IBDesignable class TabBar: UITabBar {
    @IBInspectable var color: UIColor?
    @IBInspectable var radii: CGFloat = 15.0

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        addShape()
        
        // 탭 바 아이템 색상 설정
        self.unselectedItemTintColor = UIColor(named: "off_icon_color")
        self.tintColor = UIColor(named: "on_icon_color")
    }

    // 탭 바 배경 설정
    private func addShape() {
        let shapeLayer = CAShapeLayer()

        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        shapeLayer.fillColor = UIColor(named: "tabbar_background_color")?.cgColor
        shapeLayer.lineWidth = 2

        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }
    
    // 탭 바 배경 모서리 둥글게 설정
    private func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radii, height: 0.0))

        return path.cgPath
    }
    
    // 탭 바 길이 설정
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 110 // 원하는 길이
        return sizeThatFits
    }
    

}
