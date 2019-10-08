//
//  AnswersEditableListViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 02.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let cellID = String(describing: UITableViewCell.self)

final class AnswersEditableListViewModel: NSObject, EditableListViewModel {

	private var presentableAnswer: [PresentableAnswer] {
		didSet {
			answersDidChange()
		}
	}
	private let answerSet: PresentableAnswerSet
	private let answerSetsModel: AnswerSetsModel

	init(answerSet: PresentableAnswerSet, answerSetsModel: AnswerSetsModel) {
		self.presentableAnswer = answerSet.answers
		self.answerSet = answerSet
		self.answerSetsModel = answerSetsModel
		self.listTitle = answerSet.name
		super.init()
	}

	// MARK: - EditableListViewModel

	var listTitle: String
	var nameOfItems: String = L10n.EditableItems.Name.answers
	var didSelectItem: ((Int) -> Void)?

	func numberOfItems() -> Int {
		return presentableAnswer.count
	}

	func item(at index: Int) -> String {
		return presentableAnswer[index].text
	}

	func updateItem(at index: Int, with text: String) {
		presentableAnswer[index] = PresentableAnswer(text: text)
	}

	func createNewItem(with text: String) {
		presentableAnswer.append(PresentableAnswer(text: text))
	}

	func deleteItem(at index: Int) {
		presentableAnswer.remove(at: index)
	}

	// MARK: - Private Methods

	private func answersDidChange() {
		let answers = presentableAnswer.map { Answer(from: $0)}
		let updatedAnswerSet = AnswerSet(id: answerSet.id, name: answerSet.name, answers: answers)
		answerSetsModel.save(updatedAnswerSet)
	}

}

// MARK: - UITableViewDataSource

extension AnswersEditableListViewModel {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfItems()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: UITableViewCell

		if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellID) {
			cell = dequeuedCell
		} else {
			cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
		}

		cell.textLabel?.text = presentableAnswer[indexPath.row].text

		return cell
	}

}