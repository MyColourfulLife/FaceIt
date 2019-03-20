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
