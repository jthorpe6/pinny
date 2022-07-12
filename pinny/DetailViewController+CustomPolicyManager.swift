//
//  DetailViewController+CustomPolicyManager.swift
//  pinny
//
//  Created by Joe Thorpe on 12/07/2022.
//

import Foundation
import Alamofire

final class DenyEvaluator: ServerTrustEvaluating {
    func evaluate(_ trust: SecTrust, forHost host: String) throws {
        throw AFError.serverTrustEvaluationFailed(reason: .noPublicKeysFound)
    }
}

final class CustomServerTrustPolicyManager: ServerTrustManager {
    init() {
        super.init(evaluators: [:])
    }

    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        var policy: ServerTrustEvaluating?

        /// Smarter check would be beneficial here, theoretically, MITM attack can have an URL containing this string
        if host.contains("jxtx.gitlab.io") {
            policy = PublicKeysTrustEvaluator()
        } else {
            policy = DenyEvaluator()
        }

        return policy
    }
}

extension DetailViewController {
    func requestWithCustomPolicyManager(pinning: Bool) {
        guard let urlString = endpointTextfield.text,
              let url = URL(string: urlString) else {
            showResult(success: false)
            return
        }

        if pinning {
            let manager = CustomServerTrustPolicyManager()
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
