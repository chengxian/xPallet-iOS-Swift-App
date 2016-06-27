//
//  CustomSwitch.swift
//  xPallet
//
//  Created by ChengXian Lim on 12/14/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//


import UIKit

class CustomSwitchRoundedLayer: CALayer {
    
    override var bounds: CGRect {
        didSet {
            cornerRadius = bounds.height / 2.0
        }
    }
    
}

class CustomSwitch: UIControl {
    
    var leftTitle: String {
        set { (leftTitleLabel.text, selectedLeftTitleLabel.text) = (newValue, newValue) }
        get { return leftTitleLabel.text! }
    }
    
    var rightTitle: String {
        set { (rightTitleLabel.text, selectedRightTitleLabel.text) = (newValue, newValue) }
        get { return rightTitleLabel.text! }
    }
    
    private(set)  var selectedIndex: Int = 0
    
    var selectedBackgroundInset: CGFloat = 2.0 {
        didSet { setNeedsLayout() }
    }
    
    var selectedBackgroundColor: UIColor! {
        set { selectedBackgroundView.backgroundColor = newValue }
        get { return selectedBackgroundView.backgroundColor }
    }
    
    var titleColor: UIColor! {
        set { (leftTitleLabel.textColor, rightTitleLabel.textColor) = (newValue, newValue) }
        get { return leftTitleLabel.textColor }
    }
    
    var selectedTitleColor: UIColor! {
        set { (selectedLeftTitleLabel.textColor, selectedRightTitleLabel.textColor) = (newValue, newValue) }
        get { return selectedLeftTitleLabel.textColor }
    }
    
    var titleFont: UIFont! {
        set { (leftTitleLabel.font, rightTitleLabel.font, selectedLeftTitleLabel.font, selectedRightTitleLabel.font) = (newValue, newValue, newValue, newValue) }
        get { return leftTitleLabel.font }
    }
    
    var animationDuration: NSTimeInterval = 0.3
    var animationSpringDamping: CGFloat = 0.75
    var animationInitialSpringVelocity: CGFloat = 0.0
    
    private var titleLabelsContentView = UIView()
    private var leftTitleLabel = UILabel()
    private var rightTitleLabel = UILabel()
    
    private var selectedTitleLabelsContentView = UIView()
    private var selectedLeftTitleLabel = UILabel()
    private var selectedRightTitleLabel = UILabel()
    
    private(set) var selectedBackgroundView = UIView()
    
    private var titleMaskView: UIView = UIView()
    
    private var tapGesture: UITapGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!
    
    private var initialSelectedBackgroundViewFrame: CGRect?
    
    init(leftTitle: String!, rightTitle: String!) {
        super.init(frame: CGRect.zero)
        
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        finishInit()
    }
    
    required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        finishInit()
    }
    
    override  init(frame: CGRect) {
        super.init(frame: frame)        
        finishInit()
    }
    
    private func finishInit() {
        // Setup views
        (leftTitleLabel.lineBreakMode, rightTitleLabel.lineBreakMode) = (.ByTruncatingTail, .ByTruncatingTail)
        
        titleLabelsContentView.addSubview(leftTitleLabel)
        titleLabelsContentView.addSubview(rightTitleLabel)
        addSubview(titleLabelsContentView)
        
        object_setClass(selectedBackgroundView.layer, CustomSwitchRoundedLayer.self)
        addSubview(selectedBackgroundView)
        
        selectedTitleLabelsContentView.addSubview(selectedLeftTitleLabel)
        selectedTitleLabelsContentView.addSubview(selectedRightTitleLabel)
        addSubview(selectedTitleLabelsContentView)
        
        (leftTitleLabel.textAlignment, rightTitleLabel.textAlignment, selectedLeftTitleLabel.textAlignment, selectedRightTitleLabel.textAlignment) = (.Center, .Center, .Center, .Center)
        
        object_setClass(titleMaskView.layer, CustomSwitchRoundedLayer.self)
        titleMaskView.backgroundColor = .blackColor()
        selectedTitleLabelsContentView.layer.mask = titleMaskView.layer
        
        // Setup default colors
        backgroundColor = .blackColor()
        selectedBackgroundColor = .whiteColor()
        titleColor = .whiteColor()
        selectedTitleColor = .blackColor()
        
        // Gestures
        tapGesture = UITapGestureRecognizer(target: self, action: "tapped:")
        addGestureRecognizer(tapGesture)
        
        panGesture = UIPanGestureRecognizer(target: self, action: "pan:")
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        addObserver(self, forKeyPath: "selectedBackgroundView.frame", options: .New, context: nil)        
    }
    
    deinit {
        removeObserver(self, forKeyPath: "selectedBackgroundView.frame")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "selectedBackgroundView.frame" {
            titleMaskView.frame = selectedBackgroundView.frame
        }
    }
    
    override class func layerClass() -> AnyClass {
        return CustomSwitchRoundedLayer.self
    }
    
    func tapped(gesture: UITapGestureRecognizer!) {
        let location = gesture.locationInView(self)
        if location.x < bounds.width / 2.0 {
            setSelectedIndex(0, animated: true)
        } else {
            setSelectedIndex(1, animated: true)
        }
    }
    
    func pan(gesture: UIPanGestureRecognizer!) {
        if gesture.state == .Began {
            initialSelectedBackgroundViewFrame = selectedBackgroundView.frame
        } else if gesture.state == .Changed {
            var frame = initialSelectedBackgroundViewFrame!
            frame.origin.x += gesture.translationInView(self).x
            frame.origin.x = max(min(frame.origin.x, bounds.width - selectedBackgroundInset - frame.width), selectedBackgroundInset)
            selectedBackgroundView.frame = frame
        } else if gesture.state == .Ended || gesture.state == .Failed || gesture.state == .Cancelled {
            let velocityX = gesture.velocityInView(self).x
            if velocityX > 500.0 {
                setSelectedIndex(1, animated: true)
            } else if velocityX < -500.0 {
                setSelectedIndex(0, animated: true)
            } else if selectedBackgroundView.center.x >= bounds.width / 2.0 {
                setSelectedIndex(1, animated: true)
            } else if selectedBackgroundView.center.x < bounds.size.width / 2.0 {
                setSelectedIndex(0, animated: true)
            }
        }
    }
    
    func setSelectedIndex(selectedIndex: Int, animated: Bool) {
        
        // Reset switch on half pan gestures
        var catchHalfSwitch:Bool = false
        if self.selectedIndex == selectedIndex {
            catchHalfSwitch = true
        }
        
        self.selectedIndex = selectedIndex
        if animated {
            UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: animationSpringDamping, initialSpringVelocity: animationInitialSpringVelocity, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
                self.layoutSubviews()
                }, completion: { (finished) -> Void in
                    if finished {
                        if (!catchHalfSwitch) {
                            self.sendActionsForControlEvents(.ValueChanged)
                        }
                    }
            })
        } else {
            layoutSubviews()
            sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let selectedBackgroundWidth = bounds.width / 2.0 - selectedBackgroundInset * 2.0
        selectedBackgroundView.frame = CGRect(x: selectedBackgroundInset + CGFloat(selectedIndex) * (selectedBackgroundWidth + selectedBackgroundInset * 2.0), y: selectedBackgroundInset, width: selectedBackgroundWidth, height: bounds.height - selectedBackgroundInset * 2.0)
        
        (titleLabelsContentView.frame, selectedTitleLabelsContentView.frame) = (bounds, bounds)
        
        let titleLabelMaxWidth = selectedBackgroundWidth
        let titleLabelMaxHeight = bounds.height - selectedBackgroundInset * 2.0
        
        var leftTitleLabelSize = leftTitleLabel.sizeThatFits(CGSize(width: titleLabelMaxWidth, height: titleLabelMaxHeight))
        leftTitleLabelSize.width = min(leftTitleLabelSize.width, titleLabelMaxWidth)
        
        let leftTitleLabelOrigin = CGPoint(x: floor((bounds.width / 2.0 - leftTitleLabelSize.width) / 2.0), y: floor((bounds.height - leftTitleLabelSize.height) / 2.0))
        let leftTitleLabelFrame = CGRect(origin: leftTitleLabelOrigin, size: leftTitleLabelSize)
        (leftTitleLabel.frame, selectedLeftTitleLabel.frame) = (leftTitleLabelFrame, leftTitleLabelFrame)
        
        var rightTitleLabelSize = rightTitleLabel.sizeThatFits(CGSize(width: titleLabelMaxWidth, height: titleLabelMaxHeight))
        rightTitleLabelSize.width = min(rightTitleLabelSize.width, titleLabelMaxWidth)
        
        let rightTitleLabelOrigin = CGPoint(x: floor(bounds.size.width / 2.0 + (bounds.width / 2.0 - rightTitleLabelSize.width) / 2.0), y: floor((bounds.height - rightTitleLabelSize.height) / 2.0))
        let rightTitleLabelFrame = CGRect(origin: rightTitleLabelOrigin, size: rightTitleLabelSize)
        (rightTitleLabel.frame, selectedRightTitleLabel.frame) = (rightTitleLabelFrame, rightTitleLabelFrame)
    }
    
}

// MARK: UIGestureRecognizer Delegate

extension CustomSwitch: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture {
            return selectedBackgroundView.frame.contains(gestureRecognizer.locationInView(self))
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
}