//
//  AnswerSetsModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

protocol AnswerSetsServiceProtocol {

	func loadAnswerSets(_ completionHandler: @escaping ([AnswerSet]) -> Void)
	func update(_ answerSet: AnswerSet)
	func appendNew(_ answerSet: AnswerSet)
	func delete(_ answerSet: AnswerSet)

}

protocol AnswerSetsModelObserver: class {

	func answerSetsModelDidChangeAnswerSets(_ model: AnswerSetsModel)

}

final class AnswerSetsModel {

	private let answerSetsService: AnswerSetsServiceProtocol

	init(answerSetsService: AnswerSetsServiceProtocol) {
		self.answerSetsService = answerSetsService
	}

	private var answerSets: [AnswerSet] = [] {
		didSet {
			notifyObservers()
		}
	}

	// MARK: - Public

	func loadAnswerSets() {
		answerSetsService.loadAnswerSets { (answerSets) in
			self.answerSets = answerSets
		}
	}

	func notEmptyAnswerSets() -> [AnswerSet] {
		return answerSets.filter { !$0.answers.isEmpty }
	}

	func numberOfAnswerSets() -> Int {
		return answerSets.count
	}

	func answerSet(at index: Int) -> AnswerSet {
		return answerSets[index]
	}

	func save(_ answerSet: AnswerSet) {
		if let index = answerSets.firstIndex(of: answerSet) {
			answerSets[index] = answerSet
			answerSetsService.update(answerSet)
		} else {
			answerSets.append(answerSet)
			answerSetsService.appendNew(answerSet)
		}
	}

	func deleteAnswerSet(at index: Int) {
		guard index >= 0, index < answerSets.count else { return }

		let answerSet = answerSets.remove(at: index)

		answerSetsService.delete(answerSet)
	}

	// MARK: - Observation

	private var observations: [ObjectIdentifier: Observation] = [:]

	func addObserver(_ observer: AnswerSetsModelObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: AnswerSetsModelObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

	// MARK: - Private

	private func notifyObservers() {
		observations.forEach { (id, observation) in
			if let observer = observation.observer {
				observer.answerSetsModelDidChangeAnswerSets(self)

			} else {
				observations.removeValue(forKey: id)
			}
		}
	}

}

private extension AnswerSetsModel {

	struct Observation {
        weak var observer: AnswerSetsModelObserver?
    }

}
