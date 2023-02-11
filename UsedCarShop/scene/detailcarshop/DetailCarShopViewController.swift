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
                self.tableViewDataSource.update(cars: cars)
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.carShop }
            .compactMap { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] carShop in
                guard let self = self else { return }
                self.tableViewDataSource.update(carShop: carShop)
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.carRowHeight
        tableView.register(CarShopDetailCell.self, forCellReuseIdentifier: CarShopDetailCell.id)
        tableView.register(DetailCarShopHeaderView.self, forHeaderFooterViewReuseIdentifier: DetailCarShopHeaderView.id)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDataSource
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
    static let carshopHeaderHeight: CGFloat = 100.0
}
