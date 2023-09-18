
import Foundation
import RxSwift

struct TimerCreator {
  static func count(from: Int, to: Int, quickStart: Bool) -> Observable<Int> {
    return Observable<Int>
        .timer(quickStart ? .milliseconds(0) : .milliseconds(1000), period: .milliseconds(1000), scheduler: MainScheduler.instance)
      .take(from - to + 1)
      .map { from - $0 }
    
  }
}
