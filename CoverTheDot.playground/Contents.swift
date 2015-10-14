//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var gameView: UIView! = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

let blck1 = UIView(frame: CGRect(x: 30, y: 30, width: 10, height: 10)); gameView.addSubview(blck1)
let blck2 = UIView(frame: CGRect(x: 20, y: 20, width: 10, height: 10)); gameView.addSubview(blck2)
let blck3 = UIView(frame: CGRect(x: 100, y: 100, width: 10, height: 10)); gameView.addSubview(blck3)

let dot1 = UIView(frame: CGRect(x: 20, y: 20, width: 20, height: 20)); gameView.addSubview(dot1)
let dot2 = UIView(frame: CGRect(x: 90, y: 90, width: 50, height: 50)); gameView.addSubview(dot2)

var blockSize: CGSize!

var dotSize: CGSize!

var blocksPerRow = 10

func removeCompletedRow(removeBlock: (UIView->Void)? = nil) {
    var blocksToRemove = [UIView]()
    var blockFrame = CGRect(x: 0, y: gameView.frame.maxY, width: blockSize.width, height: blockSize.height)
    
    repeat {
        blockFrame.origin.y -= blockSize.height
        blockFrame.origin.x = 0
        var blocksFound = [UIView]()
        var rowIsComplete = true
        for _ in 0 ..< blocksPerRow {
            if let hitView = gameView.hitTest(CGPoint(x: blockFrame.midX, y: blockFrame.midY), withEvent: nil) {
                if hitView.superview == gameView {
                    blocksFound.append(hitView)
                } else {
                    rowIsComplete = false
                }
            }
            blockFrame.origin.x += blockSize.width
        }
        if rowIsComplete {
            blocksToRemove += blocksFound
        }
    } while blocksToRemove.count == 0 && blockFrame.origin.y > 0
    
    for block in blocksToRemove {
        removeBlock?(block)
    }
}

func blocksCoveringDot(dotView: UIView, getBlockCount: (Int->Void)? = nil) {
    
//    var blocksCoveringDot = [UIView]()
//    var dotFrame = CGRect(x: dotView.frame.origin.x, y: dotView.frame.origin.y, width: dotSize.width, height: dotSize.height)
//    
//    repeat {
//        var blocksFound = [UIView]()
//        if let hitView = gameView.hitTest(CGPoint(x: dotFrame.midX, y: dotFrame.midY), withEvent: nil) {
//            if hitView.superview == gameView {
//                blocksFound.append(hitView)
//            } else {
//                
//            }
//        }
//        
//    } while blocksCoveringDot.count == 0 && dotFrame.origin.y > 0
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



var blocks = 0
blocksCoveringDot(dot1) {
    blockCount in
    print(blockCount)
    blocks = blockCount
}
blocks


