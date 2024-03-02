
import SwiftUI
import AuthenticationServices

struct WelcomeView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var isShowingMain: Bool = false
    @State private var isUserSignedIn: Bool = false
    
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    
    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages) { page in
                VStack(alignment: .trailing) {
                    
                    Spacer()
                    PageView(page: page)
                    Spacer()
                    if page == pages.last {
                        Registration(name: "", surname: "", phoneNumber: "")
                        Spacer()
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
