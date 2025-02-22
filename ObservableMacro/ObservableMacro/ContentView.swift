//
//  ContentView.swift
//  ObservableMacro
//
//  Created by Timmy Lau on 2025-02-21.
//

/// As of Xcode 15 and Swift 5.8
/// Observable was create - a concise way to declare obsevable state, marginal better performance.
/// migraiton from @ObservableObject, @StateObject, @ObservedObjects, @EnviromentObjects
/// to now using -> @Observable, @Bindable, @State, @Environment

import SwiftUI

/////// original way
//class CounterViewModel: ObservableObject {
//    @Published var count = 0
//}
//
//struct ObservableMacroTutorial: View {
//    @StateObject var viewModel = CounterViewModel()
//
//    var body: some View {
//        VStack {
//            Text("Count: \(viewModel.count)")
//
//
//            Button("Increment") {
//                viewModel.count += 1
//            }
//
//            ///how we achieved observability with child views previously.
//            /// if i clicked Increment oin the parent - the count updates
//            /// if i clicedk increment on the child view - the same count updates -> showing some kind of binding relationship (same VM)
//            ChildView1(viewModel: viewModel)
//                .padding()
//
//            ///another way of doing, by not having to pass the VM as an init parameter
//            ///Answer: rather its set up as an environmentObject
//            ChildView2()
//                .environmentObject(viewModel)
//
//
//        }
//    }
//}
//
//struct ChildView1: View {
//
//    @ObservedObject var viewModel: CounterViewModel
//
//    var body: some View {
//        VStack {
//            Text("Child 1 count: \(viewModel.count)")
//
//
//            Button("Increment") {
//                viewModel.count += 1
//            }
//        }
//    }
//}
//struct ChildView2: View {
//
//    @EnvironmentObject var viewModel: CounterViewModel
//
//    var body: some View {
//        VStack {
//            Text("Child 2 count: \(viewModel.count)")
//
//
//            Button("Increment") {
//                viewModel.count += 1
//            }
//        }
//    }
//}





/// Observable Way
///no need to confrom to the ObervableObject protocol anymore, less boilerplate, better syntactic sugar
///mark class with the macro
@Observable
class CounterViewModel {
    ///no need for @Published property wrappers
    /// All properties are Published by default
    /// previously: we had to add the @Published,
    /// But: its now inversed if we want it the other way and not have a property published we mark it with @ObservationIgnored
    /// - eg private properties in the VM we dont want publishing and triggering a redraw of the view.
    var count = 0
    
    // Docs: Disables observation tracking of a property.
//    @ObservationIgnored var count = 0
}

struct ObservableMacroTutorial: View {
    ///doesnt need to be a StateObject anymore - it was coupled with the ObservableObject protocol
    ///Answer: just mark as @State
    @State var viewModel = CounterViewModel()
    
    var body: some View {
        VStack {
            Text("Count: \(viewModel.count)")
        }
        
        Button("Increment") {
            viewModel.count += 1
        }
        
        
        ChildView1(viewModel: viewModel)
            .padding()
        
        
        /// ChangeL uses .environment instead of .enviromnetObject
        ChildView2()
            .environment(viewModel)
        
        
    }
}

struct ChildView1: View {
    ///error - Generic struct 'ObservedObject' requires that 'CounterViewModel' conform to 'ObservableObject'
    ///Answer: @ObservedObject gets replaced by @Bindable
    @Bindable var viewModel: CounterViewModel
    
    var body: some View {
        VStack {
            Text("Child 1 count: \(viewModel.count)")
            
            
            Button("Increment") {
                viewModel.count += 1
            }
        }
    }
}
struct ChildView2: View {
    ///error - Generic struct 'EnvironmentObject' requires that 'CounterViewModel' conform to 'ObservableObject'
    ///Answer: Change to @Environment, and add
    ///From docs: To get the observable object using its type, create a property and provide the Environment property wrapper the object’s type:
    @Environment(CounterViewModel.self) var viewModel
    
    var body: some View {
        VStack {
            Text("Child 2 count: \(viewModel.count)")
            
            
            Button("Increment") {
                viewModel.count += 1
            }
        }
    }
}



#Preview {
    ObservableMacroTutorial()
}
