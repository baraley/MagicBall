//
//  InputTextAlertController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/15/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class InputTextAlertController: NSObject, UITextFieldDelegate {

	private weak var presentingViewController: UIViewController?

	init(presentingViewController: UIViewController) {
		self.presentingViewController = presentingViewController

		super.init()
	}

	private var currentAction: UIAlertAction?

	// MARK: - Public

	func showInputTextAlert(
		withTitle title: String,
		actionTitle: String,
		textFieldPlaceholder placeholder: String = "",
		handler: @escaping ((String) -> Void)
	) {

		let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

		alert.addAction(.init(title: L10n.Action.Title.cancel, style: .cancel, handler: nil))

		alert.addTextField { [unowned self] (textField) in
			textField.text = placeholder
			textField.addTarget(self, action: #selector(self.textDidChange(in:)), for: .editingDidBegin)
			textField.addTarget(self, action: #selector(self.textDidChange(in:)), for: .editingChanged)
		}

		currentAction = UIAlertAction(title: actionTitle, style: .default) { _ in
			let textField = alert.textFields![0]

			if let text = textField.text, !text.isEmpty {
				handler(text)
			}
		}

		alert.addAction(currentAction!)

		presentingViewController?.present(alert, animated: true)
	}

	// MARK: - Text field actions

	@objc func textDidChange(in textField: UITextField) {
		if !textField.hasText {
			currentAction?.isEnabled = false
		} else {
			currentAction?.isEnabled = true
		}
	}
}
