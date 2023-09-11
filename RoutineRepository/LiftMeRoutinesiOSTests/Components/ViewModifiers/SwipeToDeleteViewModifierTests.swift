//
//  SwipeToDeleteViewModifierTests.swift
//  LiftMeRoutinesiOSTests
//
//  Created by Boyce Estes on 7/23/23.
//

import XCTest
//import ViewInspector
// This component should be internal only (Composed in this module's views)
@testable import LiftMeRoutinesiOS

/*
 * Behavior:
 * - Drag Gesture will adjust offset with drag gesture translation width
 * - View content will have an offset property that is adjusted by the drag gesture
 * - If Drag Gesture translation passes a "swipeThreshold" (like half the screen width), it will call to delete the view
 * - If the Drag Gesture translation does not pass "swipeThreshold", it will set the offset to the "deleteButtonWidth" and set "isSwiped" to true
 * - If the Drag Gesture translation does not pass "swipeThreshold" AND it does not pass "deleteButtonWidth", it will set the offset to the original value
 * - If delete button is tapped it will call the delete method
 *     - The delete method will call the delete action that is passed in AND it cause a haptic pulse
 * - If "isSwiped" is true AND the next Drag Gesture translation is positive, "isSwiped" will be set to false and the offset will be set to the original value
 */


final class SwipeToDeleteViewModifierTests: XCTestCase {}
