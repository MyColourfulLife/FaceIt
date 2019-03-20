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
    private struct BlinkRate {
        static let closeDuration:TimeInterval = 0.4
        static let openDuration:TimeInterval = 2.5
    }
    private func blinkIfNeeded(){
        if blinking {
            faceView.eyesOpen = false
            Timer.scheduledTimer(withTimeInterval: BlinkRate.closeDuration, repeats: false) {[weak self] timer in
                self?.faceView.eyesOpen = true
                Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false, block: {[weak self] timer in
                    self?.blinkIfNeeded()
                })
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blinking = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        blinking = false
    }

}
