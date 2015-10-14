//
//  ViewController.swift
//  CoverTheDot
//
//  Created by Reid Chatham on 10/13/15.
//  Copyright © 2015 Hermes Messenger LLC. All rights reserved.
//

import UIKit
import MotionKit

class ViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet weak var gameView: BezierPathsView!
    
    @IBOutlet weak var gameUpdateLabel: UILabel! {
        didSet {
            
        }
    }
    
    
    var currentRound = GameRound(gameDuration: 60) {
        didSet {
//            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("score:"), userInfo: nil, repeats: true)
        }
    }
//    func score(timer: NSTimer) {
//        print("Score match")
//        currentRound.updateScore {
//            [unowned self]
//            (var score) -> Int in
//            
//            self.blocksCoveringDot(self.dotView) {
//                blockCount in
//                score += blockCount
//            }
//            
//            self.gameUpdateLabel.text = "Time Remaining: \(self.currentRound.gameTimer.timeInterval) Score: \(score)"
//            
//            return score
//        }
//    }
    
    lazy var animator: UIDynamicAnimator = {
        let lazyAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazyAnimator.delegate = self
        return lazyAnimator
        }()
    
    var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment?.action = { [unowned self] in
                    if let attachedView = self.attachment?.items.first {
                        let path = UIBezierPath()
                        path.moveToPoint(self.attachment!.anchorPoint)
                        path.addLineToPoint(attachedView.center)
//                        self.gameView.setPath(path, named: PathNames.Attachment)
                    }
                }
            }
        }
    }
    
    struct PathNames {
//        static let MiddleBarrier = "Middle Barrier"   (ex.)
        static let Attachment = "Attachment"
    }
    
    
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        
    }
    func dynamicAnimatorWillResume(animator: UIDynamicAnimator) {
        
    }
    
    var dotView: DotView! {
        didSet {
            
        }
    }
    
    
    
    let blockBehavior = BlockBehavior()
    
    var currentSizeRatio: Int = 5
    func sizeRatio() -> Int {
        currentSizeRatio = Int.random(10) + 2
        return ++currentSizeRatio
    }
    
    var blockSize: CGSize {
        let size = gameView.bounds.size.width / CGFloat(sizeRatio())
        return CGSize(width: size, height: size)
    }
    
    var numberOfBlocks: Int = 0
    func maxBlocks() -> Int {
        numberOfBlocks = Int.random(10)
        return ++numberOfBlocks
    }
    
    var currentBlocks = [UIView]()
    
    
    @IBOutlet var tapGesture: UITapGestureRecognizer! {
        didSet {
            tapGesture.numberOfTouchesRequired = 1
            tapGesture.numberOfTapsRequired = 1
        }
    }
    @IBAction func tap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            // handling code
            print("Handle tap with ended state")
            let touchPosition = sender.locationInView(gameView)
            let size = blockSize
            let x = touchPosition.x - (size.width/2)
            let y = touchPosition.y - (size.height/2)
            let location = CGPoint(x: x, y: y)
            dropBlocks(withLocation: location, size: size)
        }
    }
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer! {
        didSet {
        }
    }
    @IBAction func longPress(sender: UILongPressGestureRecognizer) {
    }
    
    @IBOutlet var panGesture: UIPanGestureRecognizer! {
        didSet {
        }
    }
    
    @IBAction func pan(sender: UIPanGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameView)
        switch sender.state {
        case .Began:
            print("Handle pan began")
            if !currentBlocks.isEmpty {
                attachment = UIAttachmentBehavior(item: currentBlocks[currentBlocks.count-1], attachedToAnchor: gesturePoint)
            }
        case .Changed:
            print("Handle pan changed")
            attachment?.anchorPoint = gesturePoint
        case .Ended:
            print("Handle pan ended")
            attachment = nil
        default: break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        animator.addBehavior(blockBehavior)
        
        
        dotView = DotView(frame: CGRect(x: gameView.frame.size.width/2 , y: gameView.frame.size.height/2, width: 40, height: 40))
        gameView.addSubview(dotView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let motionKit = AppDelegate.Motion.Kit
        motionKit.getAccelerometerValues(){
            (x: Double, y: Double, z: Double) in
            
            self.blockBehavior.gravity.gravityDirection = CGVector(dx: x, dy: -y)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dropBlocks(size: CGSize) {
        let x = CGFloat.random(currentSizeRatio) * size.width
        let y = CGFloat.random(currentSizeRatio) * size.height
        dropBlocks(withLocation: CGPoint(x: x, y: y), size: size)
        
    }
    
    func dropBlocks(withLocation location: CGPoint, size: CGSize) {
        let frame = CGRect(origin: location, size: size)
        
        maxBlocks()
        for _ in 0..<Int.random(numberOfBlocks) {
            let blockView = UIView(frame:frame)
            blockView.backgroundColor = UIColor.random
            currentBlocks.append(blockView)
            blockBehavior.addBlock(blockView)
        }
        
        
        if currentBlocks.count >= numberOfBlocks { //maxBlocks() {
            for _ in numberOfBlocks..<currentBlocks.count {
                blockBehavior.removeBlock(currentBlocks[0])
                currentBlocks.removeAtIndex(0)
            }
        }
        let blockView = UIView(frame: frame)
        blockView.backgroundColor = UIColor.random
        currentBlocks.append(blockView)
        blockBehavior.addBlock(blockView)
        
    }
    
    func removeBlocks() {
        for block in currentBlocks {
            blockBehavior.removeBlock(block)
        }
        currentBlocks.removeAll()
    }
    
    func blocksCoveringDot(dotView: UIView, getBlockCount: (Int->Void)? = nil) {
        
        var blockCount = 0
        
        let subviewsInView = gameView.subviews
        for view in subviewsInView {
            if !dotView.isEqual(view) {
                if CGRectIntersectsRect(dotView.frame, view.frame) {
                    ++blockCount
                }
            }
        }
        getBlockCount?(blockCount)
    }

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

