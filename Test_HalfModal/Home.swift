//
//  Home.swift
//  Test_HalfModal
//
//  Created by 太田誠司 on 2021/11/23.
//

import SwiftUI

struct Home: View {
    
    @State var isShowHalfModal = false
    @State var count = 0

    var body: some View {
        ZStack {
            Image("mai")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            Button("Show half modal") {
                isShowHalfModal.toggle()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.regular)
        }
        .halfModal(isShow: $isShowHalfModal) {
            
            // ここにハーフモーダルシートに表示したいViewを定義する
            ModalSheet(count: $count)

        } onEnd: {
            print("Dismiss half modal")
        }
    }
}

struct ModalSheet: View {
    
    @Binding var count: Int
    
    var body: some View {

        ZStack {
            Color.green.opacity(0.4)
            
            VStack {
                Spacer()
                
                Button {
                    count += 1
                    print("count: \(count)")
                } label: {
                    Text("Count \(count)")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .environment(\.colorScheme, .dark)
            .ignoresSafeArea()
        }
    }
}
