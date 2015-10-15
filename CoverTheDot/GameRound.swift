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
    var scoreTimer : NSTimer!
    var timeRemaining : Int
    var scoreUpdater : (Int->Int) = {
        (var score) -> Int in
        return ++score
    }
    var shouldEndGame : (Void->()) = {}
    
    var score = 0 {
        didSet {
            if timeRemaining > 0 {
                scoreTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("scoreGame:"), userInfo: nil, repeats: false)
            }
        }
    }
    func scoreGame(timer: NSTimer) {
        print("Score game")
        timeRemaining -= 1
        score = scoreUpdater(score)
    }
    
    init(gameDuration: Int, scoreUpdater updater: (Int->Int), gameOverScenario: (Void->Void)) {
        timeRemaining = gameDuration
        scoreUpdater = updater
        shouldEndGame = gameOverScenario
        super.init()
        self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(Double(gameDuration),
            target: self, selector: Selector("gameOver:"),
            userInfo: nil, repeats: false)
        self.scoreTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("scoreGame:"), userInfo: nil, repeats: false)

    }
    
    
    func pauseGame() {
    }
    
    func resumeGame() {
    }
    
    func gameOver(sender: NSTimer) {
        
        shouldEndGame()
        
    }
}