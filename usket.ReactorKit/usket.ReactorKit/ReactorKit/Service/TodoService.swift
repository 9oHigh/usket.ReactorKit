//
//  TodoService.swift
//  usket.ReactorKit
//
//  Created by 이경후 on 2023/09/21.
//

import RxSwift

protocol TodoServiceType {
    func loadTodoList() -> Observable<[TodoItem]>
}

class TodoService: TodoServiceType {
    
    func loadTodoList() -> Observable<[TodoItem]> {
        let todoItems = [
            TodoItem(id: 1, title: "아침 먹기", isDone: false),
            TodoItem(id: 2, title: "점심 먹기", isDone: false),
            TodoItem(id: 3, title: "저녁 먹기", isDone: false)
        ]
        return Observable.just(todoItems).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
