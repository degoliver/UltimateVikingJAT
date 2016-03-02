//
//  Player.swift
//  UltimateViking
//
//  Created by Diego on 02/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import UIKit

class Line: CCSprite {
    // MARK: - Public Objects
    var status:CGFloat = 0
    
    // MARK: - Private Objects
    
    // MARK: - Life Cycle
    override init() {
        super.init()
        changeStatus(0)
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
    
    func changeStatus(status:CGFloat){
        self.status = status
        
        switch (status){
        case 1:
            spriteFrame = CCSpriteFrame.frameWithImageNamed("energiaAmarela.png") as! CCSpriteFrame
        case 2:
            spriteFrame = CCSpriteFrame.frameWithImageNamed("energiaVermelha.png") as! CCSpriteFrame
        default:
            spriteFrame = CCSpriteFrame.frameWithImageNamed("energiaVerde.png") as! CCSpriteFrame
        }
    }
    
    // MARK: - Private Methods
    
    // MARK: - Public Methods
    
    // MARK: - Delegates/Datasources
    
    // MARK: - Death Cycle
    deinit {
        // Chamado no momento de desalocacao
    }
}
