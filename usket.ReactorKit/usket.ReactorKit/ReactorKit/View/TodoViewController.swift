//
//  ViewController.swift
//  usket.ReactorKit
//
//  Created by 이경후 on 2023/09/20.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class TodoViewController: UIViewController, View, UIScrollViewDelegate {
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setConfig()
        setUI()
        setConstraint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reactor?.action.onNext(.load)
    }
    
    func bind(reactor: TodoListReactor) {
        
        reactor.state
            .map { $0.todoList }
            .bind(to: tableView.rx.items (cellIdentifier: "TodoCell", cellType: TodoCell.self)) { row, item, cell in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
            
        tableView.rx.modelSelected(TodoItem.self)
            .map { .toggleItem($0.id) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.error }
            .compactMap { $0 }
            .subscribe({ [weak self] error in
                let alertViewController = UIAlertController(title: "경고", message: "알 수 없는 오류가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                
                let alertAction = UIAlertAction(title: "오키", style: UIAlertAction.Style.default) { action in
                    alertViewController.dismiss(animated: true)
                }

                alertViewController.addAction(alertAction)
                self?.present(alertViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setConfig() {
        activityIndicator.color = .black
        tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.backgroundColor = .white
    }
    
    private func setUI() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setConstraint() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 44),
            activityIndicator.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
}
