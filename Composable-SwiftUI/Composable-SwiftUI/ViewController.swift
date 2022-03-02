//
//  ViewController.swift
//  Composable-SwiftUI
//
//  Created by 박상우 on 2022/03/02.
//

import UIKit
import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
    var count = 0
    var numberFactAlert: String?
}

enum AppAction: Equatable {
    case factAlertDismissed
    case decrementButtonTapped
    case incrementButtonTapped
    case numberFactButtonTapped
    case numberFactResponse(Result<String, ApiError>)
}

struct ApiError: Error, Equatable { }

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var numberFact: (Int) -> Effect<String, ApiError>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .factAlertDismissed:
        state.numberFactAlert = nil
        return .none
    case .decrementButtonTapped:
        state.count -= 1
        return .none
    case .incrementButtonTapped:
        state.count += 1
        return .none
    case .numberFactButtonTapped:
        return environment.numberFact(state.count)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AppAction.numberFactResponse)
    case let .numberFactResponse(.success(fact)):
        state.numberFactAlert = fact
        return .none
    case .numberFactResponse(.failure):
        state.numberFactAlert = "Could not load a number fact"
        return .none
    }
}

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                HStack {
                    Button("-") { viewStore.send(.decrementButtonTapped) }
                    Text("\(viewStore.count)")
                    Button("+") { viewStore.send(.incrementButtonTapped) }
                }
                
                Button("Number fact") { viewStore.send(.numberFactButtonTapped) }
            }
            .alert(
                item: viewStore.binding(
                    get: { $0.numberFactAlert.map(FactAlert.init(title:)) },
                    send: .factAlertDismissed
                ),
                content: { Alert(title: Text($0.title)) }
            )
        }
    }
}

struct FactAlert: Identifiable {
    var title: String
    var id: String { self.title }
}

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

