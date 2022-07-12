//
//  DetailViewController+Alamofire.swift
//  pinny
//
//  Created by Joe Thorpe on 12/07/2022.
//

import Foundation
import Alamofire

extension DetailViewController {
    func requestWithAlamofire(pinning: Bool) {
        guard let urlString = endpointTextfield.text,
              let url = URL(string: urlString) else {
            showResult(success: false)
            return
        }

        if pinning {
            let evaluators: [String: ServerTrustEvaluating] = [
                "jxtx.gitlab.io": PublicKeysTrustEvaluator()
            ]

            let manager = ServerTrustManager(evaluators: evaluators)

            session = Session(serverTrustManager: manager)
        } else {
            session = Session()
        }

        session!
            .request(url, method: .get)
            .validate()
            .response(completionHandler: { [weak self] response in
                switch response.result {
                case .success:
                    self?.showResult(success: true)
                case .failure(let error):
                    switch error {
                    case .serverTrustEvaluationFailed(let reason):
                        print(reason)

                        self?.showResult(success: false, pinError: true)
                    default:
                        self?.showResult(success: false)
                    }
                }
            })
    }
}
