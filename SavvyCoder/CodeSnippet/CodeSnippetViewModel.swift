//
//  CodeSnippetViewModel.swift
//  SavvyCoder
//
//  Created by 정준우 on 2023/09/01.
//

import Foundation
import RealmSwift
import Combine

class CodeSnippetViewModel {
    private var token: NotificationToken?
    var codeSnippetList: Results<CodeSnippetItem>!
    
    private var realm: Realm
    var dataChangeSubject = PassthroughSubject<Void, Never>()

    init() {
        do {
            realm = try Realm()
            loadData()
        } catch {
            print("Error initializing Realm: \(error)")
            fatalError("Cannot continue without Realm")
        }
    }

    func loadData() {
        codeSnippetList = realm.objects(CodeSnippetItem.self)
    }

    deinit {
        token?.invalidate()
    }

    func addCodeSnippet(codeString: String) {
        do {
            try realm.write {
                let codeSnippetItem = CodeSnippetItem()
                codeSnippetItem.codeString = codeString
                realm.add(codeSnippetItem)
            }
        } catch {
            print("Error adding to Realm: \(error)")
        }
    }
    
    func updateCodeSnippet(_ item: CodeSnippetItem, with newString: String) {
        do {
            try realm.write {
                item.codeString = newString
            }
        } catch {
            print("Error updating code snippet in Realm: \(error)")
        }
    }

    func toggleUnderstood(codeSnippetItem: CodeSnippetItem) {
        do {
            try realm.write {
                print("Toggling for item: \(codeSnippetItem.codeString)")
                codeSnippetItem.isUnderstood.toggle()
            }
        } catch {
            print("Error toggling understanding in Realm: \(error)")
        }
    }

    func deleteCodeSnippet(at index: Int) {
        guard index < codeSnippetList.count else {
            print("Error: index out of range")
            return
        }
        let itemToDelete = codeSnippetList[index]
        do {
            try realm.write {
                realm.delete(itemToDelete)
            }
        } catch {
            print("Error deleting from Realm: \(error)")
        }
    }
}
