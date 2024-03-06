
    import SwiftUI
    import AuthenticationServices

    struct WelcomeView: View {
        @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
        
        @State var isShowingMain: Bool = false
        @State private var isUserSignedIn: Bool = false
        @Binding var currentShowingView: String
        
        @State private var pageIndex = 0
        private let pages: [Page] = Page.samplePages
        private let dotAppearance = UIPageControl.appearance()
        
        @EnvironmentObject var database: Database
        @Environment(\.modelContext) var modelContex
        
        var body: some View {
            TabView(selection: $pageIndex) {
                ForEach(pages) { page in
                    ZStack {
                            Spacer()
                            PageView(page: page)
                                .ignoresSafeArea()
                            Spacer()
                        if page == pages.last {
                            ZStack{
                                Spacer()
                                PageView(page: page)
                                    .ignoresSafeArea()
                                Spacer()
                            }
                                
                            }
                            else {
                            }
                        }
                        .tag(page.tag)
                }
            }.ignoresSafeArea()
            .animation(.easeInOut, value: pageIndex)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                dotAppearance.currentPageIndicatorTintColor = .red
                dotAppearance.pageIndicatorTintColor = .gray
            }
        }
        
        func incrementPage() {
            pageIndex += 1
        }
        
        func goToZero() {
            pageIndex = 0
        }
    }


//    #Preview {
//        WelcomeView(, currentShowingView: $current)
//    }
