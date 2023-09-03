//
//  CodeSnippetItem.swift
//  SavvyCoder
//
//  Created by 정준우 on 2023/09/01.
//

import Foundation
import RealmSwift

class CodeSnippetItem: Object {
    @Persisted var codeString: String = ""
    @Persisted var isUnderstood: Bool = false
}
