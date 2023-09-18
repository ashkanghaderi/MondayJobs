
import RxCocoa
import RxSwift
import paper_onboarding
import Domain


final class OnBoardingViewModel: ViewModelType {
    private let navigator: OnBoardingNavigator
    private let useCase: Domain.OnBoardingUseCase
    
    
    let buttonColors = [AppColor.colorFF5A33,AppColor.colorC644FC, AppColor.colorFFE459]
    
    init( navigator: OnBoardingNavigator, useCase: Domain.OnBoardingUseCase) {
        self.useCase   = useCase
        self.navigator = navigator
    }
    
    
    func transform(input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let dataList: Driver<[WalkThroughModel]> = Driver.of([WalkThroughModel(title: "Online Metting", description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.", imageId: "online-meeting", order: 1),WalkThroughModel(title: "Teamwork", description: "Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.", imageId: "teamwork", order: 2),WalkThroughModel(title: "Online Metting", description: "At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est.", imageId: "good-job", order: 3)])
        
//        let data =  self.useCase.fetchOnBoarding().trackActivity(activityIndicator).trackError(errorTracker).asDriverOnErrorJustComplete()
//            .map{ result in
//
//                return result.walkThrough!.compactMap({ (item) -> WalkThroughModel in
//                    return WalkThroughModel(with: item)
//                })
//
//        }
        
        let confirmTrigger = input.confirmTrigger.do(onNext: {_ in
            self.navigator.toLanding()
        })

        return Output(confirmAction: confirmTrigger ,pages: dataList)
    }
}

extension OnBoardingViewModel{
    struct Input {
        let confirmTrigger: Driver<Void>
    }
    
    struct Output {
        let confirmAction: Driver<Void>
        let pages: Driver<[WalkThroughModel]>
    }
}

