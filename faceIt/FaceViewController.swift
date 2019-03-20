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
        let eyes:FacialExpression.Eyes = express.eyes == .open ? .closed : .open
        express = FacialExpression(eyes: eyes, mouth: express.mouth)
    }
    
    var express = FacialExpression(eyes:.closed,mouth:.smile) {
        didSet{
            updateUI()
        }
    }
    
    @objc func happierReactiveToSwipGesture() {
        express = express.happier
    }
    
    @objc func sadderReactiveToSwipGesture() {
        express = express.sadder
    }
    
    
    func updateUI() {
        switch express.eyes {
        case .closed:
            faceView?.eyesOpen = false
        case .open:
            faceView?.eyesOpen = true
        case .squinting:
            faceView.eyesOpen = false
        }
        
        switch express.mouth {
        case .smile:
            faceView?.mouthCurvature = 1.0
        case .frown:
            faceView?.mouthCurvature = -1.0
        case .neutral:
            faceView?.mouthCurvature = 0
        case .smrik:
            faceView?.mouthCurvature = -0.5
        case .grin:
            faceView?.mouthCurvature = 0.5
        }
    }
    
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

