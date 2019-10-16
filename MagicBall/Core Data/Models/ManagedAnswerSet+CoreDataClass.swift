//
//  ManagedAnswerSet+CoreDataClass.swift
//  MagicBall
//
//  Created by Alexander Baraley on 12.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedAnswerSet)
public class ManagedAnswerSet: NSManagedObject {

	public override func awakeFromInsert() {
		super.awakeFromInsert()

		id = UUID().uuidString
		dateCreated = Date()
		answers = NSOrderedSet()
	}

}

extension ManagedAnswerSet {

	func toAnswerSet() -> AnswerSet {
		let answersArray: [ManagedAnswer] = answers.array.compactMap { $0 as? ManagedAnswer}
		return AnswerSet(id: id, name: name, answers: answersArray.map { Answer(text: $0.text) })
	}

	func populateWith(_ answerSet: AnswerSet) {
		guard let context = managedObjectContext else { return }

		name = answerSet.name
		id = answerSet.id

		removeFromAnswers(answers)

		for (index, answer) in answerSet.answers.enumerated() {
			let managedAnswer = ManagedAnswer(context: context)
			managedAnswer.text = answer.text
			managedAnswer.answerSet = self

			insertIntoAnswers(managedAnswer, at: index)
		}
	}

}

extension ManagedAnswerSet {

    @nonobjc public class func makeRequest() -> NSFetchRequest<ManagedAnswerSet> {
        return NSFetchRequest<ManagedAnswerSet>(entityName: "AnswerSet")
    }

	@NSManaged private(set) var dateCreated: Date
	@NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var answers: NSOrderedSet

}

// MARK: Generated accessors for answers
extension ManagedAnswerSet {

    @objc(insertObject:inAnswersAtIndex:)
    @NSManaged public func insertIntoAnswers(_ value: ManagedAnswer, at idx: Int)

    @objc(removeObjectFromAnswersAtIndex:)
    @NSManaged public func removeFromAnswers(at idx: Int)

    @objc(insertAnswers:atIndexes:)
    @NSManaged public func insertIntoAnswers(_ values: [ManagedAnswer], at indexes: NSIndexSet)

    @objc(removeAnswersAtIndexes:)
    @NSManaged public func removeFromAnswers(at indexes: NSIndexSet)

    @objc(replaceObjectInAnswersAtIndex:withObject:)
    @NSManaged public func replaceAnswers(at idx: Int, with value: ManagedAnswer)

    @objc(replaceAnswersAtIndexes:withAnswers:)
    @NSManaged public func replaceAnswers(at indexes: NSIndexSet, with values: [ManagedAnswer])

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: ManagedAnswer)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: ManagedAnswer)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSOrderedSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSOrderedSet)

}
