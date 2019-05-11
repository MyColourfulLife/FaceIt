//
//  BlinkingFaceViewController.swift
//  faceIt
//
//  Created by JiaShu Huang on 2019/3/20.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {
    var blinking:Bool = false {
        didSet{
            blinkIfNeeded()
        }
    }
    
    override func updateUI() {
        super.updateUI()
        blinking = expression.eyes == .squinting
    }
    
    private struct BlinkRate {
        static let closeDuration:TimeInterval = 0.4
        static let openDuration:TimeInterval = 2.5
    }
    
    private var canBlink = false
    private var inABlink = false
    
    private func blinkIfNeeded(){
        if blinking && canBlink && !inABlink {
            faceView?.eyesOpen = false
            inABlink = true
            Timer.scheduledTimer(withTimeInterval: BlinkRate.closeDuration, repeats: false) {[weak self] timer in
                self?.faceView?.eyesOpen = true
                Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false, block: {[weak self] timer in
                    self?.inABlink = false
                    self?.blinkIfNeeded()
                })
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canBlink = true
        blinkIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        canBlink = false
    }

}
