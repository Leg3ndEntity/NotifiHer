import SwiftUI

struct ContentView: View {
    @State private var isActivated = false
    @State private var isChanged = false
    
    var body: some View {
        ZStack {
            ZStack{
                if isActivated{
                    CustomColor.backgroundhome
                        .ignoresSafeArea()
                }
                else{
                    CustomColor.background
                        .ignoresSafeArea()
                }
                
                Circle()
                    .foregroundColor(CustomColor.brightred)
                    .opacity(0.3)
                    .frame(width: isActivated ? 300 : 0)
                Circle()
                    .foregroundColor(Color.white)
                    .opacity(0.3)
                    .frame(width: isChanged ? 300: 0)
                
                Button{
                    withAnimation(.easeInOut(duration: 1).repeatCount(isChanged ? 0: 10000000)){
                        isChanged.toggle()
                    }
                    withAnimation(.easeInOut(duration: 1)){
                        isActivated.toggle()
                    }
                }
            label:{
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                    .padding(40)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 7)
            }
            }
        }
    }
}
#Preview {
    ContentView()
}
