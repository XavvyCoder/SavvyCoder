//
//  ViewController.swift
//  SavvyCoder
//
//  Created by 정준우 on 2023/08/05.
//

import UIKit

class ViewController: UIViewController {

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("touch", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
        ])
    }
    @objc func buttonTapped() {
        if button.backgroundColor == .black {
            button.backgroundColor = .green
        } else {
            button.backgroundColor = .black
        }
        return
    }
}

