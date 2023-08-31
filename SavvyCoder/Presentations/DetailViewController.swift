//
//  DetailViewController.swift
//  SavvyCoder
//
//  Created by 정준우 on 2023/09/01.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var codeText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = codeText
    }
}
