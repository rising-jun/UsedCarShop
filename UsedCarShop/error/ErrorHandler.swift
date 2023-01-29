//
//  ErrorHandler.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/29.
//

import RxRelay
import RxSwift

final class ErrorHandler {
    private var disposeBag = DisposeBag()
    func startHandlingError() {
        App.errorHandlingRelay.subscribe { [weak self] error in
            guard let self = self else { return }
            if let error = error.error as? NetworkError {
                self.handlingNetwork(error: error)
            }
        }.disposed(by: disposeBag)
    }
    
    private func handlingNetwork(error: NetworkError) {
        switch error {
        case .nilSelf, .invailURL, .notFound, .response, .jsonParsing:
            NSLog("ErrorLog : NetworkError = \(error.logMessage)")
        }
        noticeUserWithAlert(errorMessage: error.userMessage)
    }
    
    private func noticeUserWithAlert(errorMessage: String) {
        let alertViewController = UIAlertController(title: "ERROR", message: errorMessage, preferredStyle: .alert)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true)
    }
}

enum App {
    static let errorHandlingRelay = PublishRelay<Error>()
}

enum NetworkError: Error {
    case nilSelf
    case notFound
    case invailURL
    case response
    case jsonParsing
}
extension NetworkError {
    var logMessage: String {
        switch self {
        case .nilSelf:
            return "사용되는 인스턴스가 메모리에서 해제되었습니다."
        case .notFound:
            return "내부에서 해당 파일을 찾을 수 없습니다."
        case .invailURL:
            return "유효하지 않은 URL입니다."
        case .response:
            return "응답이 없습니다."
        case .jsonParsing:
            return "해당 데이터의 parsing을 실패하였습니다."
        }
    }
    
    var userMessage: String {
        return "서버와의 연결이 불안정합니다."
    }
}
