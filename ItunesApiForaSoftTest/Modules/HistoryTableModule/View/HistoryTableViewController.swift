//
//  HistoryTableViewController.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import UIKit

let standartCellIdentifier = "standartCellIdentifier"

class HistoryTableViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!

    // MARK: - UIViewControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getHistory()
    }

    // MARK: - Private Methods
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: standartCellIdentifier)
    }

    // MARK: - Public Properties
    weak var delegate: HistoryTableViewControllerDelegate?
    var presenter: HistoryTableViewPresenterProtocol?
}

//MARK: - UITableViewDelegate
extension HistoryTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectTabelCell(with: presenter?.history?[indexPath.row])
    }
}

//MARK: - UITableViewDataSource
extension HistoryTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: standartCellIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(.magnifyingglass)
        cell.textLabel?.text = presenter?.history?[indexPath.row]
        return cell
    }
}

// MARK: -  UIScrollViewDelegate
extension HistoryTableViewController {
    
    // dismiss keyboard when srolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tabBarVC = self.tabBarController as? TabBarViewController,
              let searchBar = tabBarVC.navigationItem.searchController?.searchBar
        else { return }
        if !(searchBar.text?.isEmpty ?? true) {
            searchBar.endEditing(true)
        }
    }
}

// MARK: -HistoryTableViewProtocol
extension HistoryTableViewController: HistoryTableViewProtocol {
    
    func setHistory(history: [String]?) {
        tableView.reloadData()
    }
}

// MARK: - HistoryTableViewControllerDelegate
protocol HistoryTableViewControllerDelegate: class {
    func didSelectTabelCell(with text: String?)
}

