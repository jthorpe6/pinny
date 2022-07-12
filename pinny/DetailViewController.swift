//
//  DetailViewController.swift
//  pinny
//
//  Created by Joe Thorpe on 12/07/2022.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {

    @IBOutlet var pinEnabledSwitch: UISwitch!
    @IBOutlet var endpointTextfield: UITextField!
    @IBOutlet var resultLabel: UILabel!

    var method: PinMethod = .alamofire
    var session: Session?

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Edit this textfield to enter another domain and simulate mismatched certificates
        endpointTextfield.text = "https://jxtx.gitlab.io/"
    }

    @IBAction private func testPin() {
        let pinning = pinEnabledSwitch.isOn
        switch method {
        case .alamofire:
            requestWithAlamofire(pinning: pinning)
        case .NSURLSession:
            requestWithURLSessionDelegate(pinning: pinning)
        case .customPolicyManager:
            requestWithCustomPolicyManager(pinning: pinning)
        }
    }

    func showResult(success: Bool, pinError: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if success {
                self.resultLabel.textColor = UIColor(red:0.00, green:0.75, blue:0.00, alpha:1.0)
                self.resultLabel.text = "🚀 Success"
            } else {
                self.resultLabel.textColor = .white
                if pinError {
                    self.resultLabel.text = "🚫 Request failed"
                } else {
                    self.resultLabel.text = "🚫 NSErrorFailingURLStringKey error" // A server with the specified hostname could not be found
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
                self?.resultLabel.text = ""
            }
        }
    }
}
