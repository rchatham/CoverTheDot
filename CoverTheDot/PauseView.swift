//
//  PauseView.swift
//  CoverTheDot
//
//  Created by Reid Chatham on 10/15/15.
//  Copyright © 2015 Hermes Messenger LLC. All rights reserved.
//

import UIKit

class PauseView: UIView {

    var resumeHandler: (Void->())?
    
    @IBAction func resume(sender: UIButton) {
        resumeHandler?()
        self.removeFromSuperview()
    }
    
    init(frame: CGRect, resumeHandler: (Void->())? = nil) {
        self.resumeHandler = resumeHandler
        super.init(frame: frame)
        print("Created PauseView")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
