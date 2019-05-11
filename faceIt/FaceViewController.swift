//
//  ViewController.swift
//  faceIt
//
//  Created by JiaShu Huang on 2019/3/4.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import UIKit


class FaceViewController: UIViewController {
    @IBOutlet weak var faceView: FaceView! {
        didSet{
            // scale
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchGesture = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchGesture)
            // tap
            let tapGesutre = UITapGestureRecognizer(target: self, action: #selector(shakeHead))
            tapGesutre.numberOfTapsRequired = 1
            faceView.addGestureRecognizer(tapGesutre)
            // swip
            let swipUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(sadderReactiveToSwipGesture))
            swipUpGesture.direction = .up
            faceView.addGestureRecognizer(swipUpGesture)
            let swipDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(happierReactiveToSwipGesture))
            swipDownGesture.direction = .down
            faceView.addGestureRecognizer(swipDownGesture)
            updateUI()
        }
    }
    
    @objc func tonggleEyes(byReactTo tapGestrue:UITapGestureRecognizer) {
        let eyes:FacialExpression.Eyes = expression.eyes == .open ? .closed : .open
        expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
    }
    
    var expression = FacialExpression(eyes:.closed,mouth:.smile) {
        didSet{
            updateUI()
        }
    }
    
    @objc func happierReactiveToSwipGesture() {
        expression = expression.happier
    }
    
    @objc func sadderReactiveToSwipGesture() {
        expression = expression.sadder
    }
    
    
    func updateUI() {
        switch expression.eyes {
        case .closed:
            faceView?.eyesOpen = false
        case .open:
            faceView?.eyesOpen = true
        case .squinting:
//            faceView?.eyesOpen = false
            break
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    private let mouthCurvatures:[FacialExpression.Mouth: Double] = [.frown:-1.0,.smrik:-0.5,.neutral:0.0,.grin:0.5,.smile:1.0]
    
    private func rotateFace(by angle:CGFloat) {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private struct HeadShake {
        static let angle = CGFloat.pi/6
        static let segmentDuration:TimeInterval = 0.5
    }
    
  @objc  private func shakeHead(){
        UIView.animate(withDuration: HeadShake.segmentDuration, animations: {self.rotateFace(by: HeadShake.angle)}) { finished in
            if finished {
                UIView.animate(withDuration: HeadShake.segmentDuration, animations: {self.rotateFace(by: HeadShake.angle * -2)}) { finished in
                    if finished {
                        UIView.animate(withDuration: HeadShake.segmentDuration, animations: {self.rotateFace(by: HeadShake.angle)})
                    }
                }
            }
        }
    }
    
}

