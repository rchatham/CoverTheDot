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
    var scoreUpdater : (Int->Int) = { //Set this if you need to automatically check for updates to the score
        (var score) -> Int in
        return score
        }
    var shouldEndGame : (Void->()) = {}
    var isPaused = false
    
    var score = 0 {
        didSet {
            if timeRemaining > 0 {
//                scoreTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("scoreGame:"), userInfo: nil, repeats: false)
            } else {
                scoreTimer.invalidate()
            }
        }
    }
    
    init(gameDuration: Int, scoreUpdater updater: (Int->Int), gameOverScenario: (Void->Void)) {
        timeRemaining = gameDuration
        scoreUpdater = updater
        shouldEndGame = gameOverScenario
        super.init()
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(Double(gameDuration),
            target: self, selector: Selector("gameOver:"),
            userInfo: nil, repeats: false)
        scoreTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("scoreGame:"), userInfo: nil, repeats: true)

    }
    
    func updateScore(updater: (Int->Int)) { //Use when you want to manually update the score
        score = updater(score)
    }
    
    func scoreGame(timer: NSTimer) {
        print("Score game")
        timeRemaining -= 1
        score = scoreUpdater(score)
    }
    
    func pauseGame() {
        
        let gameTimerRemaining = gameTimer.fireDate.timeIntervalSinceNow
        if gameTimerRemaining > 0 {
            gameTimer.invalidate()
            scoreTimer.invalidate()
            timeRemaining = Int(gameTimerRemaining)
            
            isPaused = true
        }
    }
    
    func resumeGame() {
        
        if isPaused {
            gameTimer = NSTimer.scheduledTimerWithTimeInterval(Double(timeRemaining),
                target: self, selector: Selector("gameOver:"),
                userInfo: nil, repeats: false)
            scoreTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("scoreGame:"), userInfo: nil, repeats: true)
            
            isPaused = false
        }
    }
    
    func gameOver(sender: NSTimer) {
        
        shouldEndGame()
        
    }
}