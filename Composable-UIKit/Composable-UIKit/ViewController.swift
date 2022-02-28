//
//  ViewController.swift
//  Composable-UIKit
//
//  Created by 박상우 on 2022/02/28.
//

import UIKit
import ComposableArchitecture
import Combine

public struct AppState: Equatable {
    var count: Int = 0
    
    public init(counter: Int = 0) {
        self.count = counter
    }
}

public enum AppAction: Equatable {
    case decreaseButtonTapped
    case increaseButtonTapped
}

public let appReducer = Reducer<AppState, AppAction, Void> { state, action, _ in
    switch action {
    case .decreaseButtonTapped:
        state.count -= 1
        return .none
    case .increaseButtonTapped:
        state.count += 1
        return .none
    }
}


class ViewController: StateStoreViewController<AppState, AppAction> {
    
    private lazy var stackView: UIStackView = {
      let stackView = UIStackView(arrangedSubviews: [decrementButton, countLabel, incrementButton])
      stackView.translatesAutoresizingMaskIntoConstraints = false
      return stackView
    }()

    private lazy var countLabel: UILabel = {
      let label = UILabel()
      label.text = "\(viewStore.count)"
      label.font = .preferredFont(forTextStyle: .title2)
      return label
    }()

    private lazy var incrementButton: UIButton = {
      let button = UIButton(primaryAction: UIAction { [unowned self] _ in
          self.viewStore.send(.increaseButtonTapped)
      })
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle("+", for: .normal)
      return button
    }()

    private lazy var decrementButton: UIButton = {
      let button = UIButton(primaryAction: UIAction { [unowned self] _ in
          self.viewStore.send(.decreaseButtonTapped)
      })
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle("-", for: .normal)
      return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(stackView)
        self.view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.bindView()
    }
    
    private func bindView() {
        self.viewStore.publisher
            .map { "\($0.count)"}
            .assign(to: \.text, on: countLabel)
            .store(in: &self.cancellables)
    }

}
