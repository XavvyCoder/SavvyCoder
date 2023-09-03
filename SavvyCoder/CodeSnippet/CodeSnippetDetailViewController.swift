//
//  CodeSnippetDetailViewController.swift
//  SavvyCoder
//
//  Created by 정준우 on 2023/09/01.
//

import UIKit

protocol CodeSnippetDetailViewControllerDelegate: AnyObject {
    func didUpdateCodeString(to newString: String)
}

class CodeSnippetDetailViewController: UIViewController {
    
    weak var delegate: CodeSnippetDetailViewControllerDelegate?
    
    @IBOutlet weak var textView: UITextView!
    var codeString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
        setupNavBar()
    }
    
    func setUpTextView() {
        textView.text = codeString
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8.0
        textView.clipsToBounds = true
    }

    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
    }
    
    @objc func didTapSaveButton() {
        delegate?.didUpdateCodeString(to: textView.text)
        navigationController?.popViewController(animated: true)
    }
}
