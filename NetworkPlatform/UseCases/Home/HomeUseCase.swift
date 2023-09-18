
import Foundation
import Domain
import RxSwift
public final class HomeUseCase: Domain.HomeUseCase {
    
    
    @LazyInjected private var service: HomeService
    
    public init(){}
    
    public func fetchExhibition() -> Observable<ExhibitionModel.Response> {
       return service.fetchExhibition()
    }
    
    public func searchExhibition(query: String) -> Observable<[PanelModel]>{
        return service.searchExhibition(query: query)
    }
    
    public func fetchWatchList() -> Observable<[WatchModel]> {
        return service.fetchWatchList()
    }
    
    public func setWatch(companyId: String) -> Observable<WatchModel> {
        return service.setWatch(companyId: companyId)
    }
    
    public func deleteWatch(companyId: String) -> Observable<WatchModel> {
        return service.deleteWatch(companyId: companyId)
    }
    
    
}
