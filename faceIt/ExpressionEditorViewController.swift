//
//  ExpressionEditorViewController.swift
//  faceIt
//
//  Created by JiaShu Huang on 2019/5/10.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import UIKit

class ExpressionEditorViewController: UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var eyeControl: UISegmentedControl!
    @IBOutlet weak var mouthControl: UISegmentedControl!
    
    // MARK: - Model
    var name:String {
        return nameTextField?.text ?? ""
    }
    private let eyeChoices:[FacialExpression.Eyes] = [.open,.closed,.squinting]
    private let mouthChoices:[FacialExpression.Mouth] = [.frown,.smrik,.neutral,.grin,.smile]
    var expression:FacialExpression {
        return FacialExpression(eyes: eyeChoices[eyeControl?.selectedSegmentIndex ?? 0], mouth: mouthChoices[mouthControl?.selectedSegmentIndex ?? 0])
    }

    private var faceViewController:BlinkingFaceViewController?
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Add Emotion" && name.isEmpty {
            hanleUnnamedFace()
            return false
        }else {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    func hanleUnnamedFace() {
        let alert = UIAlertController(title: "无效的表情", message: "请输入表情名称", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            if let textFiled = alert.textFields?.first {
                if let text = textFiled.text, !text.isEmpty {
                    self.nameTextField?.text = text
                    self.performSegue(withIdentifier: "Add Emotion", sender: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Embed Face" {
            faceViewController = segue.destination as? BlinkingFaceViewController
            faceViewController?.expression = expression
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 适配iPad，设置preferredContentSize
        if let popoverPesentationController = navigationController?.popoverPresentationController,
            popoverPesentationController.arrowDirection != .unknown {
            navigationItem.leftBarButtonItem = nil
            var size = tableView.minimumSize(forSection: 0)
            size.height -= tableView.heightForRow(at: IndexPath(row: 1, section: 0))
            size.height += size.width
            preferredContentSize = size
        }
    }

 

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
    
    @IBAction func updateFace(_ sender: UISegmentedControl) {
        faceViewController?.expression = expression
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return tableView.bounds.size.width
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}

extension UITableView {
    func minimumSize(forSection section:Int)->CGSize {
        var width:CGFloat = 0
        var height:CGFloat = 0
        for row in 0..<numberOfRows(inSection: section) {
            let indexPath = IndexPath(row: row, section: section)
            if let cell = cellForRow(at: indexPath) ?? dataSource?.tableView(self, cellForRowAt: indexPath) {
                let cellSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                width = max(width, cellSize.width)
                height += cell.frame.height
            }
        }
        return CGSize(width: width, height: height)
    }
    
    func heightForRow(at indexPath:IndexPath? = nil)->CGFloat {
        if indexPath != nil, let height = delegate?.tableView?(self, heightForRowAt: indexPath!) {
            return height
        } else {
            return rowHeight
        }
    }
}
