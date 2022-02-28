//
//  StateStoreViewController.swift
//  Composable-UIKit
//
//  Created by 박상우 on 2022/02/28.
//

import UIKit
import ComposableArchitecture
import Combine

open class StateStoreViewController<State: Equatable, Action>: UIViewController {
    
    open var store: Store<State, Action>
    
    open var viewStore: ViewStore<State, Action>
    
    open var cancellables: Set<AnyCancellable> = []
    
    public init(store: Store<State, Action>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available(*, unavailable) public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
