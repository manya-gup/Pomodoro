//
//  ContentView.swift
//  Pomodoro
//
//  Created by Manya Gupta on 5/28/24.
//

import SwiftUI
import UIKit


struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View{
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
        
    
}

struct ContentView: View {
    
    @StateObject private var vm = ViewModel()
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var isDarkMode = false
    @Environment(\.colorScheme) var colorScheme
    
    
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let width: Double = 250
    
    var body: some View {
        Group {
            if orientation.isLandscape {
                HStack {
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 20)
                                .opacity(0.20)
                                .frame(width: width)
                                .foregroundColor(.gray)
                                                
                            Circle()
                                .trim(from: CGFloat(1.0 - vm.progress), to: 1.0)
                                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                    .foregroundColor(.blue)
                                    .rotationEffect(.degrees(-90))
                                    .animation(.easeInOut(duration: 1.0))
                                    .frame(width: width)

                            Text("\(vm.time)")
                                .font(.system(size: 70, weight: .medium, design: .rounded))
                                .padding()
                                .frame(width: width)
                        }

                        HStack(spacing: 50) {
                            Button("Start") {
                                vm.start(minutes: vm.minutes)
                            }
                            .disabled(vm.isActive)

                            Button("Reset", action: vm.reset)
                                .tint(.red)
                        }
                        .frame(width: width)
                        .padding()
                    }
                    .frame(maxWidth: .infinity)

                    VStack {
                        Slider(value: $vm.minutes, in: 25...60, step: 1)
                            .padding()
                            .frame(width: width)
                            .disabled(vm.isActive)

                        HStack(spacing: 100) {
                            Button("30 Minute") {
                                vm.start(minutes: 1)
                                vm.is50 = false
                                vm.is25 = true
                            }
                            .disabled(vm.isActive)

                            Button("1 Hour") {
                                vm.start(minutes: 2)
                                vm.is50 = true
                                vm.is25 = false
                            }
                            .disabled(vm.isActive)
                        }
                        .frame(width: width)
                        
                        Button("Light/Dark Mode") {
                            isDarkMode.toggle()
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                        }
                        .padding()
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    
                }
                .onReceive(timer) { _ in
                    vm.updateCountdown()
                }
                .alert(isPresented: $vm.showingAlert) {
                    if vm.isStudying {
                        return Alert(
                            title: Text("Timer Done!"),
                            message: Text("Take a Break?"),
                            primaryButton: .default(Text("Yes")) {
                                vm.isStudying = false
                                if vm.is25 {
                                    vm.start(minutes: 5)
                                } else {
                                    vm.start(minutes: 10)
                                }
                            },
                            secondaryButton: .cancel(Text("No")) {
                                vm.isStudying = true
                                if vm.is25 {
                                    vm.start(minutes: 25)
                                } else {
                                    vm.start(minutes: 50)
                                }
                            }
                        )
                    } else {
                        return Alert(
                            title: Text("Break Over!"),
                            message: Text("Back to Work?"),
                            primaryButton: .default(Text("Yes")) {
                                vm.isStudying = true
                                if vm.is25 {
                                    vm.start(minutes: 25)
                                } else {
                                    vm.start(minutes: 50)
                                }
                            },
                            secondaryButton: .cancel(Text("No")) {
                                vm.isStudying = false
                                if vm.is25 {
                                    vm.start(minutes: 5)
                                } else {
                                    vm.start(minutes: 10)
                                }
                            }
                        )
                    }
                }
            } else if orientation == .portrait || orientation == .portraitUpsideDown || orientation == .unknown {
                VStack {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(0.20)
                            .frame(width: width)
                            .foregroundColor(.gray)
                                            
                        Circle()
                            .trim(from: CGFloat(1.0 - vm.progress), to: 1.0)
                                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                .foregroundColor(.blue)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 1.0))
                                .frame(width: width)
                                            
                        Text("\(vm.time)")
                            .font(.system(size: 70, weight: .medium, design: .rounded))
                            .padding()
                            .frame(width: width)
                    }

                    Slider(value: $vm.minutes, in: 25...60, step: 1)
                        .padding()
                        .frame(width: width)
                        .disabled(vm.isActive)

                    HStack(spacing: 50) {
                        Button("Start") {
                            vm.start(minutes: vm.minutes)
                        }
                        .disabled(vm.isActive)

                        Button("Reset", action: vm.reset)
                            .tint(.red)
                    }
                    .frame(width: width)
                    .padding()

                    HStack(spacing: 100) {
                        Button("30 Minute") {
                            vm.start(minutes: 30)
                            vm.is50 = false
                            vm.is25 = true
                        }
                        .disabled(vm.isActive)

                        Button("1 Hour") {
                            vm.start(minutes: 60)
                            vm.is50 = true
                            vm.is25 = false
                        }
                        .disabled(vm.isActive)
                    }
                    .frame(width: width)
                    
                    Button("Light/Dark Mode") {
                                            isDarkMode.toggle()
                                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                                        }
                                        .padding()
                }
                .onReceive(timer) { _ in
                    vm.updateCountdown()
                }
                .alert(isPresented: $vm.showingAlert) {
                    if vm.isStudying {
                        return Alert(
                            title: Text("Timer Done!"),
                            message: Text("Take a Break?"),
                            primaryButton: .default(Text("Yes")) {
                                vm.isStudying = false
                                if vm.is25 {
                                    vm.start(minutes: 5)
                                } else {
                                    vm.start(minutes: 10)
                                }
                            },
                            secondaryButton: .cancel(Text("No")) {
                                vm.isStudying = true
                                if vm.is25 {
                                    vm.start(minutes: 25)
                                } else {
                                    vm.start(minutes: 50)
                                }
                            }
                        )
                    } else {
                        return Alert(
                            title: Text("Break Over!"),
                            message: Text("Back to Work?"),
                            primaryButton: .default(Text("Yes")) {
                                vm.isStudying = true
                                if vm.is25 {
                                    vm.start(minutes: 25)
                                } else {
                                    vm.start(minutes: 50)
                                }
                            },
                            secondaryButton: .cancel(Text("No")) {
                                vm.isStudying = false
                                if vm.is25 {
                                    vm.start(minutes: 5)
                                } else {
                                    vm.start(minutes: 10)
                                }
                            }
                        )
                    }
                }
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }

    
    
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
