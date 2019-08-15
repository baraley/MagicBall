//
//  AppRootViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class AppRootViewController: UITabBarController {
	
	// MARK: - Private properties
		
	private lazy var settingsModelController: SettingsModelController = .init()
	
	private lazy var answerSetsModelController: AnswerSetsModelController = .init()
	
	private var magicBallViewController: MagicBallViewController?
	
	private var settingsViewController: SettingsViewController?
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
	}
	
	private func parseViewControllers() {
		viewControllers?.forEach({
			
			if let magicBallVC = $0 as? MagicBallViewController {
				
				magicBallViewController = magicBallVC
				
			} else if let navVC = $0 as? UINavigationController,
				let settingsVC = navVC.viewControllers[0] as? SettingsViewController {
				
				settingsViewController = settingsVC
			}
		})
	}
	
	private func setup() {
		view.backgroundColor = .white
		
		parseViewControllers()
		setupMagicBallViewController()
		setupSettingsViewController()
		
		answerSetsModelController.answerSetsDidChangeHandler = { [weak self]  in
			guard let self = self else { return }
			
			self.setupMagicBallViewController()
		}
	}
	
	private func setupMagicBallViewController() {
		magicBallViewController?.settingsModel = settingsModelController.currentSettinsModel
		magicBallViewController?.answerSetsModelController = answerSetsModelController
	}
	
	private func setupSettingsViewController() {
		settingsViewController?.settingsModel = settingsModelController.currentSettinsModel
		settingsViewController?.answerSetsModelController = answerSetsModelController
		
		settingsViewController?.settingsDidChangeAction = { [weak self] (settingsModel) in
			guard let self = self else { return }
			
			self.settingsModelController.save(settingsModel)
			
			self.setupMagicBallViewController()
		}
	}
}