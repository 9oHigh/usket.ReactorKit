//
//  TodoListReactor.swift
//  usket.ReactorKit
//
//  Created by 이경후 on 2023/09/21.
//

import RxSwift
import ReactorKit

class TodoListReactor: Reactor {
    
    // View를 통해 들어오는 Action
    enum Action {
        case load
        case toggleItem(Int)
    }
    
    // Action을 통해 실질적으로 할 동작들
    enum Mutation {
        case setLoading(Bool)
        case setTodoList([TodoItem])
        case setError(Error)
        case toggleItem(Int)
    }
    
    // Mutation(실질적으로 할 동작)에 따라 상태를 변화
    struct State {
        var todoList: [TodoItem] = []
        var isLoading: Bool = false
        var error: Error?
    }
    
    // 반드시 초기 State가 있어야함
    // 생성자에서 받아도 상관없음
    let initialState = State()
    private let todoService: TodoService
    
    init(todoService: TodoService) {
        self.todoService = todoService
    }
    
    // 액션이 들어오면 호출
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
    
    // mutate가 실행된 이후 상태를 변경
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
