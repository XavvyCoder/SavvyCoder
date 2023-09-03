//
//  CodeSnippetViewController.swift
//  SavvyCoder
//
//  Created by 정준우 on 2023/09/01.
//

import UIKit
import Combine
import RealmSwift

class CodeSnippetViewController: UIViewController {
    let viewModel = CodeSnippetViewModel()
    private var cancellables: Set<AnyCancellable> = []
    var notificationToken: NotificationToken? = nil
    var selectedIndexPath: IndexPath?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupBindings()
        setupNavBar()
        setupRealmNotifications()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupBindings() {
        viewModel.dataChangeSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
                self?.checkForEmptyState()
            }
            .store(in: &cancellables)
    }
    
    func checkForEmptyState() {
        if viewModel.codeSnippetList.isEmpty {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            emptyLabel.text = "No data available."
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .black
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }

    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCodeSnippetItem))
    }
    
    @objc func addCodeSnippetItem() {
        let alert = UIAlertController(title: "Add Code Snippet Item", message: "Enter a code snippet", preferredStyle: .alert)
        alert.addTextField()
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self?.viewModel.addCodeSnippet(codeString: text)
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func setupRealmNotifications() {
        notificationToken = viewModel.codeSnippetList.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}

// MARK: - UITableViewDataSource
extension CodeSnippetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.codeSnippetList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CodeSnippetCell", for: indexPath) as? CodeSnippetTableViewCell
        else {
           fatalError("Expected CodeSnippetTableViewCell")
        }
        let item = viewModel.codeSnippetList[indexPath.row]
        cell.textLabel?.text = item.codeString
        cell.updateIconButton(isUnderstood: item.isUnderstood)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteCodeSnippet(at: indexPath.row)
        }
    }
}

// MARK: - UITableViewDelegate
extension CodeSnippetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CodeSnippet", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "CodeSnippetDetailView") as? CodeSnippetDetailViewController {
            detailVC.codeString = viewModel.codeSnippetList[indexPath.row].codeString
            detailVC.delegate = self
            navigationController?.pushViewController(detailVC, animated: true)
        }
        selectedIndexPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - CodeSnippetTableViewCellDelegate
extension CodeSnippetViewController: CodeSnippetTableViewCellDelegate {
    func didTapIcon(in cell: CodeSnippetTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.toggleUnderstood(codeSnippetItem: viewModel.codeSnippetList[indexPath.row])
    }
}

// MARK: - CodeSnippetDetailViewControllerDelegate
extension CodeSnippetViewController: CodeSnippetDetailViewControllerDelegate {
    func didUpdateCodeString(to newString: String) {
        guard let indexPath = selectedIndexPath else { return }
        let itemToUpdate = viewModel.codeSnippetList[indexPath.row]
        viewModel.updateCodeSnippet(itemToUpdate, with: newString)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        selectedIndexPath = nil
    }
}
