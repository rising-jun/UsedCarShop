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
    }
    
    enum Mutation {
        case updateCameraPoint(Location?, LocationPermission)
        case updateCarShopPoint
        case none
    }
    
    struct State {
        var userPoint: Location? = Location(lat: 0.0, lng: 0.0)
        var locationPermission: LocationPermission = .available
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
             
            return Observable.concat([requestUserLocation().map { Mutation.updateCameraPoint($0, $1)},
                                      .just(.updateCarShopPoint)])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateCameraPoint(let location, let permission):
            newState.locationPermission = permission
            newState.userPoint = location
        case .updateCarShopPoint:
            print("")
        case .none:
            print("")
        }
        return newState
    }
}
private extension ArroundShopMapReactor {
    func requestUserLocation() -> PublishSubject<(Location?, LocationPermission)> {
        let userLocationSubject = PublishSubject<(Location?, LocationPermission)>()
        Task {
            let result = await usecase.requestUserLocation()
            userLocationSubject.onNext((result.0, result.1))
        }
        return userLocationSubject
    }
}
