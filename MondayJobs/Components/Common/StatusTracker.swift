
import Foundation
import RxSwift
import RxCocoa



final class StatusTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = BehaviorSubject<ServiceStatus>(value: .loading)

    func trackStatus<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        onLoading()
        return source.asObservable()
            .do(onError: onError)
            .do(onNext:{[weak self] _ in
                guard let self = self else {return}; self.onSuccess()})
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, ServiceStatus> {
        return _subject.asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<ServiceStatus> {
        return _subject.asObserver()
    }

    private func onError(_ error: Error) {
        _subject.onNext(.failed(error: error))
    }
    
    private func onLoading() {
        _subject.onNext(.loading)
    }
    
    private func onSuccess() {
           _subject.onNext(.succeed)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackStatus(_ statusTracker: StatusTracker) -> Observable<Element> {
        return statusTracker.trackStatus(from: self)
    }
}
// MARK: - ServiceStatus

public enum ServiceStatus: Equatable {
    case loading
    case succeed
    case failed(error: Error)
    
    var errorMessage: String {
        switch self {
        case .failed(let error):
            return error.localizedDescription
        default:
            return "Unknown status"
        }
    }
    
    var isFailed:Bool{
        switch self {
        case .failed( _):
            return true
            
        default:
            return false
        }
    }
    
    public static func ==(lhs: ServiceStatus, rhs: ServiceStatus) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.succeed, .succeed):
            return true
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}


