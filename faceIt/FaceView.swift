//
//  FaceView.swift
//  faceIt
//
//  Created by JiaShu Huang on 2019/3/4.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import UIKit


@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var scale:CGFloat = 0.9 {didSet{setNeedsDisplay()}}
    @IBInspectable
    var eyesOpen:Bool = false {didSet{setNeedsDisplay()}}
    @IBInspectable
    var mouthCurvature:Double = 1.0 {didSet{setNeedsDisplay()}} // 1.0 - -1.0
    @IBInspectable
    var lineColor:UIColor = UIColor.blue {didSet{setNeedsDisplay()}}
    @IBInspectable
    var lineWidth:CGFloat = 5
    
    var skullRadius:CGFloat {
        return min(bounds.size.width, bounds.size.height)/2 * max(0.1, min(3, scale))
    }
    
    var skullCenter:CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
   @objc func changeScale(byReactingTo pinchRecognizer:UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed,.ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:break
        }
    }

    private func pathForCircleAtPoint(_ centerPoint:CGPoint, radius:CGFloat)->UIBezierPath {
        let path = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private struct Ratios {
        static let skullRadiusToEyeOffset:CGFloat = 3
        static let skullRadiusToEyeRadius:CGFloat = 10
        static let skullRadiusToMounthWidth:CGFloat = 1
        static let skullRadiusToMounthHeight:CGFloat = 3
        static let skullRadiusToMounthHeightOffset:CGFloat = 3
        static let skullRadiusToBrowOffset:CGFloat = 5

    }
    
    private func pathForEye(_ eye:Eye)->UIBezierPath {
        func getEyeCenter(eye:Eye)->CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            switch eye {
            case .left:
                eyeCenter.x -= eyeOffset
            case .right:
                eyeCenter.x += eyeOffset
            }
            return eyeCenter
        }
        
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        let path:UIBezierPath
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: false)
        }else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x-eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x+eyeRadius, y: eyeCenter.y))
        }
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForMounth()->UIBezierPath{
        let mouthWidth = skullRadius/Ratios.skullRadiusToMounthWidth
        let mouthHeight = skullRadius/Ratios.skullRadiusToMounthHeight
        let mouthOffset = skullRadius/Ratios.skullRadiusToMounthHeightOffset
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        let smileOffset = CGFloat(max(-1,min(1,mouthCurvature))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.midY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.midY + smileOffset)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        lineColor.set()
        pathForCircleAtPoint(skullCenter, radius: skullRadius).stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMounth().stroke()
    }
}
