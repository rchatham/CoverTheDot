//
//  GameRound.swift
//  CoverTheDot
//
//  Created by Reid Chatham on 10/13/15.
//  Copyright © 2015 Hermes Messenger LLC. All rights reserved.
//

import Foundation


class GameRound : NSObject {
    
    var gameTimer : NSTimer!
    
    var score = 0
    
    init(gameDuration: NSTimeInterval) {
        super.init()
        self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(gameDuration,
            target: self, selector: Selector("gameOver:"),
            userInfo: nil, repeats: false)
    }
    
    func updateScore(updater: (Int->Int) ) {
        score = updater(score)
    }
    
    func pauseGame() {
    }
    
    func resumeGame() {
        
    }
    
    func gameOver(sender: NSTimer) {
        
    }
}