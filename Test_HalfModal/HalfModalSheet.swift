//
//  HalfModalSheet.swift
//  Test_HalfModal
//
//  Created by 太田誠司 on 2021/11/23.
//  https://raw.githubusercontent.com/ueshun109/SwiftUIStylebook/main/SwiftUIStylebook/UIComponents/HalfModalView.swift
//
//  https://stackoverflow.com/questions/67982691/ios-15-using-uisheetpresentationcontroller-in-swiftui
//

import SwiftUI

extension View {
    func halfModal<Sheet: View>(
        isShow: Binding<Bool>,
        @ViewBuilder sheet: @escaping () -> Sheet,
        onEnd: @escaping () -> ()
    ) -> some View {
        return self
            .background(
                HalfModalSheet(
                    sheet: sheet(),
                    isShow: isShow,
                    onClose: onEnd
                )
            )
    }
}

struct HalfModalSheet<Sheet: View>: UIViewControllerRepresentable {
    var sheet: Sheet
    @Binding var isShow: Bool
    var onClose: () -> Void
        
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(
        _ viewController: UIViewController,
        context: Context
    ) {
        if isShow {
            let sheetController = CustomHostingController(rootView: sheet)
            sheetController.presentationController!.delegate = context.coordinator
            sheetController.view.backgroundColor = nil
            context.coordinator.isVisible = true
            viewController.present(sheetController, animated: true)
        } else {
            if context.coordinator.isVisible {
                viewController.dismiss(animated: true) { onClose() }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class CustomHostingController<Content: View>: UIHostingController<Content> {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let sheet = self.sheetPresentationController {
                sheet.detents = [.medium(),]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 24.0
            }
        }
    }
    
    final class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfModalSheet
        var isVisible = false
        
        init(parent: HalfModalSheet) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.isShow = false
        }
    }
}
