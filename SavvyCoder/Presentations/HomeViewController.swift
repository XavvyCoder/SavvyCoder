//
//  HomeViewController.swift
//  SavvyCoder
//
//  Created by 정준우 on 2023/08/31.
//

import UIKit

class HomeViewController: UIViewController {
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("memorizable\nswift codes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.frame.size.width = 300
        button.frame.size.height = 400
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func buttonTapped() {
        print("yeah")
    }
}
