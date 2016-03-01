//
//  HomeScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

// MARK: - Class Definition
class HomeScene : CCScene {
	// MARK: - Public Objects

	// MARK: - Private Objects
	private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()

	// MARK: - Life Cycle
	override init() {
		super.init()
        
        let background: CCSprite = CCSprite(imageNamed: "bgCenario-ipad.png")
        background.anchorPoint = CGPointMake(0.0, 0.0)
        background.position = CGPointMake(0.0, 0.0)
        self.addChild(background)

		let label:CCLabelTTF = CCLabelTTF(string: "The Ultimate \nViking", fontName: "Verdana", fontSize: 90.0)
        label.horizontalAlignment = CCTextAlignment.Center
        label.color = CCColor.blackColor()
		label.position = CGPointMake(self.screenSize.width/2, self.screenSize.height - 150)
		label.anchorPoint = CGPointMake(0.5, 0.5)
		self.addChild(label)
        
        let labelBestScore:CCLabelTTF = CCLabelTTF(string: "Best Score: 0", fontName: "Verdana", fontSize: 50.0)
        labelBestScore.color = CCColor.blackColor()
        labelBestScore.position = CGPointMake(self.screenSize.width/2, 40)
        labelBestScore.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(labelBestScore)
        
        let img1: CCSprite = CCSprite(imageNamed: "player-ipad.png")
        img1.position = CGPointMake(100,self.screenSize.height/2)
        img1.scaleX = 3
        img1.scaleY = 3
        self.addChild(img1)

		// ToGame Button
		let toGameButton:CCButton = CCButton(title: "[ Start ]", fontName: "Verdana-Bold", fontSize: 38.0)
        toGameButton.color = CCColor.blackColor()
		toGameButton.position = CGPointMake(self.screenSize.width/2.0, self.screenSize.height/2.0)
		toGameButton.anchorPoint = CGPointMake(0.5, 0.5)
//		toGameButton.setTarget(self, selector:"startTap:")
		toGameButton.block = {_ in StateMachine.sharedInstance.changeScene(StateMachineScenes.GameScene, isFade:true)}
		self.addChild(toGameButton)
	}

	override func onEnter() {
		// Chamado apos o init quando entra no director
		super.onEnter()
	}

	// MARK: - Private Methods
//	func startTap(sender:AnyObject) {
//		StateMachine.sharedInstance.changeScene(StateMachine.StateMachineScenes.GameScene, isFade:true)
//	}

	// MARK: - Public Methods

	// MARK: - Delegates/Datasources

	// MARK: - Death Cycle
	override func onExit() {
		// Chamado quando sai do director
		super.onExit()
	}
}
