//
//  TodoListReactor.swift
//  usket.ReactorKit
//
//  Created by 이경후 on 2023/09/21.
//

import RxSwift
import ReactorKit

class TodoListReactor: Reactor {
    
    enum Action {
        case load
        case toggleItem(Int)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setTodoList([TodoItem])
        case setError(Error)
        case toggleItem(Int)
    }
    
    struct State {
        var todoList: [TodoItem] = []
        var isLoading: Bool = false
        var error: Error?
    }
    
    let initialState = State()
    private let todoService: TodoService
    
    init(todoService: TodoService) {
        self.todoService = todoService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return todoService.loadTodoList()
                .map { .setTodoList($0) }
                .startWith(.setLoading(true))
                .catch { .just(.setError($0)) }
        case .toggleItem(let id):
            return .just(.toggleItem(id))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setTodoList(let todoList):
            newState.todoList = todoList
            newState.isLoading = false
        case .setError(let error):
            newState.error = error
            newState.isLoading = false
        case .toggleItem(let id):
            if let index = newState.todoList.firstIndex(where: { $0.id == id }) {
                newState.todoList[index].isDone.toggle()
            }
        }
        return newState
    }
}
