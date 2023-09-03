//
//  CodeSnippetTableViewCell.swift
//  SavvyCoder
//
//  Created by 정준우 on 2023/09/03.
//

import UIKit

protocol CodeSnippetTableViewCellDelegate: AnyObject {
    func didTapIcon(in cell: CodeSnippetTableViewCell)
}

class CodeSnippetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconButton: UIButton!
    weak var delegate: CodeSnippetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func iconTapped(_ sender: UIButton) {
        delegate?.didTapIcon(in: self)
    }
    
    func updateIconButton(isUnderstood: Bool) {
        if isUnderstood {
            self.iconButton.alpha = 0.8
        } else {
            self.iconButton.alpha = 0.1
        }
    }
}
