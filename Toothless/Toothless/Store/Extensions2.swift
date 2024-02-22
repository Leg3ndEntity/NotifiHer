//
//  Extensions2.swift
//  Toothless
//
//  Created by Andrea Romano on 22/02/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func bottomSheet2<Content: View>(
        presentationDetents: Set<PresentationDetent>,
        isPresented: Binding<Bool>,
        dragIndicator: Visibility = .visible,
        sheetCornerRadius: CGFloat?,
        isTransparentBG: Bool = false,
        interactiveDisabled: Bool = true,
        @ViewBuilder content: @escaping ()->Content,
        onDismiss: @escaping ()->()
    )->some View {
        self
            .sheet(isPresented: isPresented) {
                onDismiss()
            } content: {
                content()
                    .presentationDetents(presentationDetents)
                    .presentationDragIndicator(dragIndicator)
                    .onAppear {
                        guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                            return
                        }
                        if let controller = windows.windows.first?.rootViewController?.presentedViewController, let sheet = controller.presentationController as? UISheetPresentationController {
                            
                            controller.presentingViewController?.view.tintAdjustmentMode = .normal
                            sheet.preferredCornerRadius = sheetCornerRadius
                        }else {
                            print("sos")
                        }
                    }
            }
    }
}

