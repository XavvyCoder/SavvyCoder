//
//  CodeListViewController.swift
//  SavvyCoder
//
//  Created by 정준우 on 2023/09/01.
//

import UIKit

class CodeListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewItems = ["""
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
""",
                          """
find . -name .DS_Store -print0 | xargs -0 git rm --ignore-unmatch -f
""",
                          """
Thread.callStackSymbols.forEach{print($0)}
""",
    """
@frozen struct AnyPublisher<Output, Failure> where Failure : Error
""",
    """
@frozen struct AnySubscriber<Input, Failure> where Failure : Error
""",
    """
protocol Publisher<Output, Failure>
""",
    """
protocol Cancellable
""",
    """
protocol Subscriber<Input, Failure> : CustomCombineIdentifierConvertible
""",
    """
protocol Subscription : Cancellable, CustomCombineIdentifierConvertible
""",
    """
protocol Subject<Output, Failure> : AnyObject, Publisher
""",
    """
protocol Scheduler<SchedulerTimeType>
"""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension CodeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = tableViewItems[indexPath.row]
        return cell
    }
}

extension CodeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let storyboard = UIStoryboard(name: "CodeListView", bundle: nil)
        
        
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            detailVC.codeText = tableViewItems[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
