//: Please build the scheme 'RxSwiftPlayground' first
import PlaygroundSupport
import RxSwift
import RxCocoa

PlaygroundPage.current.needsIndefiniteExecution = true

func feedMilk() throws {
    print(#function)
}

func changeDiaper() throws {
    print(#function)
}

func lullBabyToSleep() throws {
    print(#function)
}

func sleep() {
    print(#function)
}

func random() -> Int {
    let min = 1
    let max = 4
    return Int(arc4random_uniform(UInt32(1 + max - min))) + min
}

let bag = DisposeBag()

enum InfentCry {
    case hungry
    case pee
    case shit
    case sleepy
    case unknow
}

class Infent {
    private let behaviour = PublishSubject<InfentCry>()
    
    var cry: Observable<InfentCry> {
        return behaviour.asObservable()
    }
    
    func somethingWrong() {
        switch random() {
        case 1: behaviour.onNext(.hungry)
        case 2: behaviour.onNext(.pee)
        case 3: behaviour.onNext(.shit)
        case 4: behaviour.onNext(.sleepy)
        default:
            behaviour.onNext(.unknow)
        }
    }
}

let id = Infent()
id.cry
    .filter { cause in cause == .hungry }
    .subscribe { _ in try! feedMilk() }
    .disposed(by: bag)

id.cry
    .filter { cause in cause == .pee || cause == .shit }
    .subscribe { _ in try! changeDiaper() }
    .disposed(by: bag)

id.cry
    .filter { cause in cause == .sleepy }
    .subscribe { _ in try! lullBabyToSleep() }
    .disposed(by: bag)

id.cry
    .filter { cause in cause == .unknow }
    .subscribe { _ in
        try! feedMilk()
        try! changeDiaper()
        try! lullBabyToSleep()
    }
    .disposed(by: bag)

id.somethingWrong()
id.somethingWrong()
id.somethingWrong()
id.somethingWrong()
id.somethingWrong()
id.somethingWrong()
id.somethingWrong()
id.somethingWrong()

