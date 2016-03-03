//
//  PowerUp.swift
//  UltimateViking
//
//  Created by Usuário Convidado on 02/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import UIKit

class PowerUp: CCSprite {
    internal var eventSelector:Selector?
    internal var targetID:AnyObject?
    
    var canTap:Bool = true
    
    convenience init(event:Selector, target:AnyObject) {
        self.init()
        self.eventSelector = event
        self.targetID = target
    }
    
    override init() {
        super.init(imageNamed: "powerUP.png")
        self.userInteractionEnabled = true
    }
    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        if (!(self.targetID as! GameScene).canPlay) {
            return
        }
        
        if(self.canTap){
            self.canTap = false

        self.runAction(CCActionSequence.actionOne(CCActionFadeOut.actionWithDuration(0.5) as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
            self.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
        
        DelayHelper.sharedInstance.callFunc(self.eventSelector!,
            onTarget: self.targetID!, withDelay: 0.0)
        }
    }
    
    override func onEnter() {
        // Chamado apos o init quando entra no director
        super.onEnter()
    }
    
    override init(CGImage image: CGImage!, key: String!) {
        super.init(CGImage: image, key: key)
    }
    
    override init(spriteFrame: CCSpriteFrame!) {
        super.init(spriteFrame: spriteFrame)
    }
    
    override init(texture: CCTexture!) {
        super.init(texture: texture)
    }
    
    override init(texture: CCTexture!, rect: CGRect) {
        super.init(texture: texture, rect: rect)
    }
    
    override init(texture: CCTexture!, rect: CGRect, rotated: Bool) {
        super.init(texture: texture, rect: rect, rotated: rotated)
    }
    
    override init(imageNamed imageName: String!) {
        super.init(imageNamed: imageName)
    }
}
