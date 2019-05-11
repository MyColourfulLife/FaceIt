# FaceIt

It comes form Standford class

CustomView

1. In order to make our custom view and it's properties can be used in StoryBoard, We can use IBDesignable before our view calss and IBInspectable before our properties.

2. There are two ways to draw a view
    - use context
    - use path
    
3. pay attention to the contentMode, you can set its value to Redraw with code or xib

4. We usually use CGFloat data type when it comes to UI.

---

In the MVC architecture, for those operations that affect the view through the model, usually, the model data is manipulated to update the UI instead of directly manipulating the UI.

There are two sides to using a gesture recognizer
1. Adding a gesture recognizer to a UIView (asking the UIView to recognize that gesture)
2. Providing a method to handle that gesture ( not necessary handled by the UIView)

The second is provided either by the UIView or a Contrller depending on the situation
1. if affect the model , use Controller
2. if not ,use UIView

```swift
@IBOutlet weak var faceView: FaceView! {
    didSet{
    let handler = #selector(FaceView.changeScale(byReactingTo:))
    let pinchGesture = UIPinchGestureRecognizer(target: faceView, action: handler)
    faceView.addGestureRecognizer(pinchGesture)
    }
}

@objc func changeScale(byReactingTo pinchRecognizer:UIPinchGestureRecognizer) {
    switch pinchRecognizer.state {
    case .changed,.ended:
    scale *= pinchRecognizer.scale
    pinchRecognizer.scale = 1
    default:break
    }
}
```
The property observers didSet code gets called when iOS hooks up this outlet at runtime

Here we are creating an instance of a concrete subclass of UIGes tureRecognizer (for pans)

The target gets notified when the gesture is recognized (here it's the Controller itself)

The action is the method invoked on recognition (that method's argument? the recognizer)

Here we ask the UIView to actually start trying to recognize this gesture in its bounds

by reseting the scale to one, the next one we get will be incremental movement, we also reset the translation to CGPoint.zero in the panGesture

---

We can use splitViewController to adopt the ipad and the ios platform

The VIewContoller's life circle:

1. instantiated (from storyboard usually)
2. awakFromNib
3. segue preparation happens
4. outlets get set
5. viewDidLoad(all outlets are set , but the gemoetry of your view is not set yet! for example its bounds not set)
6. these pairs will be called each time your Controller's view goes on/off screen ...
    viewWillAppear and viewDIdAppear
    viewWillDisappear and viewDidDisappear
7. these "geometry changed" mothods might be called at any time after viewDidLoad ...
    viewWillLayoutSubviews (... then autolayout happens,then ...)viewDidLayoutSubviews
    you can reset the frames of your subviews here or set other geometry-related properties

---
Use timer to bling bling
Use animation to open and close your eyes
Use animation to achieve moving head

---
- Add emotion editor with static tableView
- Adapt to iPhone and iPad
- Use Embed Segue to Embed other Controller's view
- Calculate the height of the popover controller
```swift
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
```
- Use Unwind segue to pass value backwards
```swift
    @IBAction func addEmotionalFace(from segue:UIStoryboardSegue) {
        if let editor = segue.source as? ExpressionEditorViewController {
            emotionalFaces.append((editor.name,editor.expression))
            tableView.reloadData()
        }
    }
```
- Use should segue method to verify the validity of the input value
```swift
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Add Emotion" && name.isEmpty {
            hanleUnnamedFace()
            return false
        }else {
            return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        }
    }
```
- Use alert to ask user input the emotion name or cancel it
```swift
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
```

