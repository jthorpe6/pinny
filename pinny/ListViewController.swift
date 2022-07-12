//
//  ListViewController.swift
//  pinny
//
//  Created by Joe Thorpe on 12/07/2022.
//

import UIKit

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Method list"
    }

    @IBAction private func _showAlamofirePin() {
        _showDetailViewController(method: .alamofire)
    }

    @IBAction private func _showCustomPolicyPin() {
        _showDetailViewController(method: .customPolicyManager)
    }

    @IBAction private func _showURLSessionPin() {
        _showDetailViewController(method: .NSURLSession)
    }

    private func _showDetailViewController(method: PinMethod) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.method = method
        navigationController?.pushViewController(detailViewController, animated: true)
    }

}
