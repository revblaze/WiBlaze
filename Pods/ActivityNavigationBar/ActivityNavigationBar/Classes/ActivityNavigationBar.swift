//
//  Created by Pete Smith
//  http://www.petethedeveloper.com
//
//
//  License
//  Copyright © 2016-present Pete Smith
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit

/*
 Activity navigation bar provides a custom navigation bar with a build in
 activity indicator. The activity indicator is styled like a progress bar, 
 but is intended to be used to indicate indeterminate activity time.
 
 To achieve this, the activity is started with a 'waitAt' parameter.
 The activity bar will then animate progress to this point, and stop.
 Then, once our indeterminate activity has finished, we finish the 
 activity indicator.
 
*/
@IBDesignable
open class ActivityNavigationBar: UINavigationBar {
    
    /// Activity bar color
    @IBInspectable open var activityBarColor: UIColor? {
        didSet {
            guard let activityBarColor = activityBarColor else { return }
            
            activityBarView?.tintColor = activityBarColor
        }
    }
    
    // MARK: - Properties (Private)
    fileprivate var activityBarView: UIProgressView?
    fileprivate var activityBarHeightConstraint: NSLayoutConstraint?
    
    fileprivate var startTimer: Timer?
    fileprivate var waitValue: Float = 0.8
    fileprivate var finishTimer: Timer?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: API
    
    
    /// Start the activity bar from progress 0, specifying a value to wait/stop at
    ///
    /// - Parameter waitValue: Value between 0 and 1
    open func startActivity(andWaitAt waitValue: Float) {
        
        guard waitValue > 0 && waitValue < 1 else {
            fatalError("The waitValue must be between 0 and 1")
        }
        
        activityBarView?.isHidden = false
        activityBarView?.progress = 0.0
        
        self.waitValue = waitValue
        
        startTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                            selector: #selector(updateStartProgress),
                                                            userInfo: nil, repeats: true)
    }
    
    
    /// Finish the activity bar, animating to a progress of 1, 
    /// using the specified animation duration
    ///
    /// - Parameter duration: The animation duration
    open func finishActivity(withDuration duration: Double, andCompletion completion: (() -> Void)? = nil) {
        
        startTimer?.invalidate()
        
        activityBarView?.progress = 1
        
        UIView.animate(withDuration: duration, animations: {
            self.activityBarView?.layoutIfNeeded()
        }, completion: { finished in
            
            self.activityBarView?.isHidden = true
            self.activityBarView?.progress = 0.0
            
            completion?()
        })
    }
    
    /// Reset the activity bar to 0 progress
    open func reset() {
        
        activityBarView?.isHidden = true
        activityBarView?.setProgress(0, animated: false)
    }
    
    // MARK: - Activity bar progress
    
    @objc
    fileprivate func updateStartProgress() {
        
        guard let activityBarView = activityBarView else { return }
        
        guard let startTimer = startTimer, startTimer.isValid else { return }
        
        guard activityBarView.progress < waitValue else {
            startTimer.invalidate()
            return
        }
        
        activityBarView.setProgress(activityBarView.progress + 0.1, animated: true)
    }
    
    // MARK: - Initialization
    
    fileprivate func commonInit() {
        
        addActivityView()
    }
    
    fileprivate func addActivityView() {
        
        // Create our progress view
        
        activityBarView = UIProgressView(progressViewStyle: .bar)
        
        // Set it's initial frame
        
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 3.0
        let yPosition = bounds.height - height
        
        activityBarView?.frame = CGRect(x: 0, y: yPosition, width: width, height: height)
        
        guard let activityBarView = activityBarView else { return }
        
        // Use a transform to set the desired height of 3
        
        let transform  = CGAffineTransform(scaleX: 1.0, y: 1.5)
        activityBarView.transform = transform
        
        // Add to the navigation bar
        addSubview(activityBarView)
        
        // Appearance
        
        // Initially hide the progress view
        activityBarView.isHidden = true
        
        // Color
        activityBarView.tintColor = .orange
        activityBarView.trackTintColor = .clear
    }
}
