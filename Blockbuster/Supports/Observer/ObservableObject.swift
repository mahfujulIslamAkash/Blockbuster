//
//  ObservableObject.swift
//  Blockbuster
//
//  Created by Temp on 10/5/24.
//  This observableObject more easy to use and easy to customise
//  This object will act or work for combine/observe VM/RxSwift
//  I preffer to use custom binds, and is easy to replace with combine

import Foundation

final class ObservableObject<T>{
    var value: T{
        didSet{
            listener?(value)
        }
    }
    private var listener: ((T)->Void)?
    init(_ value: T){
        self.value = value
    }
    
    func binds(_ listener: @escaping(T)-> Void){
        listener(value)
        self.listener = listener
        
    }
}
