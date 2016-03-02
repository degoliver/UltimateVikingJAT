//
//  PlayerAxe.swift
//  UltimateViking
//
//  Created by Diego on 02/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import UIKit

class PlayerAxe: CCSprite {
    var damage:CGFloat = 1.0
    
    // MARK: - Private Objects
    
    // MARK: - Life Cycle
    override init() {
        super.init(imageNamed: "tiro.png")
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
        
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Dynamic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "PlayerAxe"
        self.physicsBody.collisionCategories = ["PlayerAxe"]
        self.physicsBody.collisionMask = ["Enemy"]
    }
    
    convenience init(damage:CGFloat) {
        self.init(imageNamed: "tiro.png")
        
        // Configuracoes default
        self.damage = damage
        
    }
    
    override func onEnter() {
        // Chamado apos o init quando entra no director
        super.onEnter()
    }
    
    // MARK: - Private Methods
    
    // MARK: - Public Methods
    
    // MARK: - Delegates/Datasources
    
    // MARK: - Death Cycle
    deinit {
        // Chamado no momento de desalocacao
    }
}
