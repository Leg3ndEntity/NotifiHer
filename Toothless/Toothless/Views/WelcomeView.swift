import SwiftUI

struct WelcomeView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var isShowingMain: Bool = false
    
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()

    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages) { page in
                VStack(alignment: .trailing) {
                    // Skip Button
                    Button("Skip", action: {
                        isWelcomeScreenOver = true
                        isShowingMain.toggle()
                    })
                    .foregroundColor(.blue)
                    .padding(.trailing, 20)
                    
                    Spacer()
                    PageView(page: page)
                    Spacer()
                    if page == pages.last {
                        HStack {
                            Spacer()
                            Text("Get started")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                            Spacer()
                        }
                            .onTapGesture {
                                isWelcomeScreenOver = true
                                isShowingMain.toggle()
                                print("ciao")
                            }
                    }
                    else {
                        HStack {
                            Spacer()
                            Button("Next", action: incrementPage)
                                .buttonStyle(.borderedProminent)
                                .font(.title2)
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .tag(page.tag)
            }
        }
        .animation(.easeInOut, value: pageIndex)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .red
            dotAppearance.pageIndicatorTintColor = .gray
        }
        .fullScreenCover(isPresented: $isShowingMain, content: {
            CompleteTimer()
        })
    }
    
    func incrementPage() {
        pageIndex += 1
    }

    func goToZero() {
        pageIndex = 0
    }
}

#Preview {
    WelcomeView()
}
