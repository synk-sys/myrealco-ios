import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 260, height: 260)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
