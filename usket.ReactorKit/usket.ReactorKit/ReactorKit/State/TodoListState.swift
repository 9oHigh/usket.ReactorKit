//
//  TodoListState.swift
//  usket.ReactorKit
//
//  Created by 이경후 on 2023/09/21.
//

import Foundation

enum TodoListState {
    case loading
    case loaded([TodoItem])
    case error(Error)
}
