//
//  ExerciseUIComposerWithSpys.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 2/12/23.
//

import Foundation
import NavigationFlow
import SwiftUI
import RoutineRepository
@testable import LiftMeApp


//
//enum UIComposerMessage {
//    case dismissModal
//}
//
//
//class ExerciseUIComposerWithSpys: ExerciseUIComposer {
//
//    enum BaseState {
//        case createExerciseViewDisplayed
//    }
//
//
//    var messages = [UIComposerMessage]()
//
//
//    convenience init(baseState: BaseState? = nil) {
//        self.init(routineStore: RoutineStoreSpy())
//        
//        switch baseState {
//        case .createExerciseViewDisplayed:
//            navigationFlow.modallyDisplayedView = makeCreateExerciseViewSheetyIdentifier()
//        default:
//            navigationFlow.modallyDisplayedView = nil
//        }
//    }
//
//
//
//    func makeCreateExerciseViewSheetyIdentifier() -> ExerciseNavigationFlow.SheetyIdentifier {
//
//        let createExerciseViewDismissClosure: (Exercise?) -> Void = { _ in self.messages.append(.dismissModal) }
//
//        return .createExerciseView(
//            dismiss: createExerciseViewDismissClosure,
//            uuid: UUID()
//        )
//    }
//}
