//
//  DetailCarShopReactor.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/02/01.
//

import ReactorKit

final class DetailCarShopReactor: Reactor {
    private let carShopDTO: CarShopDTO
    var usecase = DetailCarShopUsecase()
    var initialState = State()
    
    init(carShopDTO: CarShopDTO) {
        self.carShopDTO = carShopDTO
    }
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case updateCars([CarDTO])
    }
    
    struct State {
        var cars = [CarDTO]()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return requestDetailCars().map { .updateCars($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateCars(let cars):
            newState.cars = cars
        }
        return newState
    }
}
private extension DetailCarShopReactor {
    func requestDetailCars() -> Observable<[CarDTO]> {
        return Observable<[CarDTO]>.create { [weak self] observer in
            guard let self = self else { return Disposables.create { } }
            let task = Task {
                let carshops = await self.usecase.requestDetailCars(by: self.carShopDTO.id)
                observer.onNext(carshops ?? [])
            }
            return Disposables.create { task.cancel() }
        }
    }
}
