//
//  EmotionsViewController.swift
//  faceIt
//
//  Created by JiaShu Huang on 2019/3/6.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationContrlloer = segue.destination
        if let navigationController = destinationContrlloer as? UINavigationController {
            destinationContrlloer = navigationController.visibleViewController ?? destinationContrlloer
        }
        
        if let faceViewController = destinationContrlloer as? FaceViewController,
            let identifier = segue.identifier,
            let expresion = emotions[identifier] {
            faceViewController.express = expresion
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    }

    let emotions:[String:FacialExpression] = ["happy":FacialExpression(eyes:.open,mouth:.smile),
        "sad":FacialExpression(eyes: .closed, mouth: .frown),
        "worried":FacialExpression(eyes: .open, mouth: .smrik)]
}

