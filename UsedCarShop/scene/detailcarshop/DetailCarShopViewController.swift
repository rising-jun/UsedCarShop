//
//  DetailCarShopViewController.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/02/01.
//

import SnapKit
import ReactorKit
import RxSwift

final class DetailCarShopViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    func bind(reactor: DetailCarShopReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.cars }
            .filter { $0.count > 0 }
            .take(1)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] cars in
                guard let self = self else { return }
                
            }.disposed(by: disposeBag)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.carRowHeight
        tableView.register(CarShopDetailCell.self, forCellReuseIdentifier: CarShopDetailCell.id)
        return tableView
    }()
    
    private let tableViewDataSource = DetailCarTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAttribute()
    }
}
private extension DetailCarShopViewController {
    func viewAttribute() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.dataSource = tableViewDataSource
        layout()
    }
    
    func layout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension UITableView {
    static let carRowHeight: CGFloat = 124.0
    static let favoriteRowHeight: CGFloat = 83.0
}
