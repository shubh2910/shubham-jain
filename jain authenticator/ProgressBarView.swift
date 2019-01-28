//
//  ProgressBarView.swift
//  Malayala Manorama
//
//  Created by Shubham Jain on 11/01/19.
//  Copyright © 2019 Malayala Manorama. All rights reserved.

import Foundation
import UIKit
class ProgressBarView: UIView {
    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!


private func createCirclePath() {
    let x = self.frame.width/2
    let y = self.frame.height/2
    let center = CGPoint(x: x, y: y)
    bgPath.addArc(withCenter: center, radius: x/CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat(6.28), clockwise: true)
    bgPath.close()
}
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
        self.simpleShape()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bgPath = UIBezierPath()
        self.simpleShape()
    }
func simpleShape() {
    createCirclePath()
    shapeLayer = CAShapeLayer()
    shapeLayer.path = bgPath.cgPath
    shapeLayer.lineWidth = 5
    shapeLayer.fillColor = nil
    shapeLayer.strokeColor = UIColor.lightGray.cgColor
    progressLayer = CAShapeLayer()
    progressLayer.path = bgPath.cgPath
    progressLayer.lineWidth = 5
//    progressLayer.lineCap = CAShapeLayerLineCap.round
    progressLayer.fillColor = nil
    progressLayer.strokeColor = UIColor.green.cgColor
    progressLayer.strokeEnd = 0.0
    self.layer.addSublayer(shapeLayer)
    self.layer.addSublayer(progressLayer)
}
var progress: Float = 0 {
    willSet(newValue)
    {
        progressLayer.strokeEnd = CGFloat(newValue)    }
  }

}
