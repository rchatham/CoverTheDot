//
//  DotView.swift
//  CoverTheDot
//
//  Created by Reid Chatham on 10/13/15.
//  Copyright © 2015 Hermes Messenger LLC. All rights reserved.
//

import UIKit

class DotView: BezierPathsView {
    
    
    var dot: UIBezierPath {
        let path = UIBezierPath(ovalInRect: CGRect(origin: self.frame.origin, size: self.frame.size))
        return path
    }
    
    struct PathNames {
        static let DotPath = "Dot Path"
    }
    
    var currentSizeRatio: Int = 5
    func sizeRatio() -> Int {
        currentSizeRatio = Int.random(5) + 2
        return currentSizeRatio
    }
    
    var dotSize: CGSize {
        let size = superview!.bounds.size.width / CGFloat(sizeRatio())
        return CGSize(width: size, height: size)
    }
    
    override var frame: CGRect {
        didSet {
            self.layer.cornerRadius = self.bounds.size.width/2
            self.clipsToBounds = true
            self.backgroundColor = UIColor.random
//            setPath(dot, named: PathNames.DotPath)
            
            _ = NSTimer.scheduledTimerWithTimeInterval(Double(Int.random(5)+1),
                target: self, selector: Selector("moveDot:"),
                userInfo: nil,
                repeats: false)
        }
    }
    func moveDot(timer: NSTimer) {
        print("Move dot")
        let size = dotSize
        let x = CGFloat.random(Int(superview!.frame.size.width - size.width))
        let y = CGFloat.random(Int(superview!.frame.size.height - size.height))
        let frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
        
//        UIView.animateWithDuration(1.0, animations: {
//            [unowned self] in
//            self.frame = frame
//            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            [unowned self] in
            self.frame = frame
            }, completion: nil)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

private extension Int {
    static func random(max: Int) -> Int {
        return Int(arc4random() % UInt32(max))
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random()%5 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.redColor()
        case 3: return UIColor.yellowColor()
        case 4: return UIColor.magentaColor()
        default: return UIColor.blackColor()
        }
    }
}