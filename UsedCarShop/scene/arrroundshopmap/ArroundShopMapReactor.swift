//
//  ArroundShopMapReactor.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/29.
//

import ReactorKit

final class ArroundShopMapReactor: Reactor {
    
    let usecase = ArroundShopMapUsecase()
    var initialState = State()
    
    enum Action {
        case viewDidLoad
        case tapUserLocation
    }
    
    enum Mutation {
        case updateCameraPoint(Location?, LocationPermission)
        case updateCarShopPoints([CarShopDTO]?)
        case none
    }
    
    struct State {
        var userPoint: Location? = Location(lat: 0.0, lng: 0.0)
        var locationPermission: LocationPermission = .available
        var carshops: [CarShopDTO] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.merge(
                                      requestUserLocation().map { Mutation.updateCameraPoint($0, $1)},
                                      requestCarShopPoints().map { Mutation.updateCarShopPoints($0)}
                                     )
        case .tapUserLocation:
            return .just(.updateCameraPoint(currentState.userPoint, currentState.locationPermission))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateCameraPoint(let location, let permission):
            print("updateCameraPoint")
            newState.locationPermission = permission
            newState.userPoint = location
        case .updateCarShopPoints(let carshops):
            print("updated carshop!!")
            newState.carshops = carshops ?? []
        case .none:
            print("")
        }
        return newState
    }
}
private extension ArroundShopMapReactor {
    func requestUserLocation() -> Observable<(Location?, LocationPermission)> {
        return Observable<(Location?, LocationPermission)>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let task = Task {
                observer.onNext(await self.usecase.requestUserLocation())
            }
            return Disposables.create { task.cancel() }
        }
    }
    
    func requestCarShopPoints() -> Observable<[CarShopDTO]?> {
        return Observable<[CarShopDTO]?>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let task = Task {
                observer.onNext(await self.usecase.requestCarShopModel())
            }
            return Disposables.create { task.cancel() }
        }
    }
}
