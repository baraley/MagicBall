//
//  NetworkService.swift
//  Gallery
//
//  Created by Alexander Baraley on 1/8/18.
//  Copyright © 2018 Alexander Baraley. All rights reserved.
//

import Foundation

protocol NetworkRequest {
	associatedtype ResultModel
	associatedtype ResultError: Error

	var urlRequest: URLRequest { get }

	func decode(_ data: Data?, response: URLResponse?, error: Error?) -> Result<ResultModel, ResultError>
}

class NetworkService {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    deinit {
        cancelAllRequests()
    }

    private var tasks: [URL: URLSessionDataTask] = [:]

	func performRequest<T: NetworkRequest>(
		_ request: T, with completionHandler: @escaping (Result<T.ResultModel, T.ResultError>) -> Void
		) {

		guard let url = request.urlRequest.url, tasks[url] == nil else { return }

		let dataTask = session.dataTask(with: request.urlRequest) { [weak self] (data, response, error) in
			DispatchQueue.main.async { self?.tasks[url] = nil }

			let result = request.decode(data, response: response, error: error)
			completionHandler(result)
		}
		tasks[url] = dataTask
		dataTask.resume()
	}

    func cancel<T: NetworkRequest>(_ request: T) {
        if let url = request.urlRequest.url, let task = tasks[url] {
            task.cancel()
        }
    }

    private func cancelAllRequests() {
        tasks.forEach { $1.cancel() }
    }
}

extension NetworkService: NetworkAnswerService {

	func loadAnswer(with completionHandler: @escaping AnswerSourcesModel.CompletionHandler) {
		let answerRequest = AnswerRequest()

		performRequest(answerRequest) { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let networkAnswer):
					let answer = networkAnswer.toAnswer()
					completionHandler(.success(answer))

				case .failure(let error):

					completionHandler(.failure(error))
				}
			}
		}
	}
}
