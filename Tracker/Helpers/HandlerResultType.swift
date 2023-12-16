//
//  HandlerResultType.swift
//  Tracker
//
//  Created by Григррий Машук on 15.12.23.
//

import UIKit

final class HandlerResultType {
    func resultTypeHandler<Value>(_ listCategory: Result<Value, Error>, handler: (Value) -> Void) {
        switch listCategory {
        case .success(let newValue):
            handler(newValue)
        case .failure(let error):
            showMessageErrorAlert(message: error.localizedDescription)
        }
    }
    
    func resultTypeHandlerGetValue<Value>(_ value: Result<Value, Error>) -> Value? {
        switch value {
        case .success(let newValue):
            return newValue
        case .failure(let error):
            showMessageErrorAlert(message: error.localizedDescription)
            return nil
        }
    }
    
    private func showMessageErrorAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
    }
}
