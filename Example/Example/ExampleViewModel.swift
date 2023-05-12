//
//  ExampleViewModel.swift
//  Example
//
//  Created by Degirmenci Emre on 12.05.2023.
//

import Foundation
import Combine
import UIKit.UIImage

final class ExampleViewModel {

    let images = CurrentValueSubject<[Onboarding], Never>([
        Onboarding(color: UIColor(named: "dark")!, title: "Lorem ipsum dolor set amet"),
        Onboarding(color: UIColor(named: "purple")!, title: "Lorem ipsum dolor set amet"),
        Onboarding(color: UIColor(named: "yellow")!, title: "Lorem ipsum dolor set amet"),
        Onboarding(color: UIColor(named: "cyan")!, title: "Lorem ipsum dolor set amet"),
        Onboarding(color: UIColor(named: "red")!, title: "Lorem ipsum dolor set amet"),
        Onboarding(color: UIColor(named: "green")!, title: "Lorem ipsum dolor set amet"),
    ])
}

