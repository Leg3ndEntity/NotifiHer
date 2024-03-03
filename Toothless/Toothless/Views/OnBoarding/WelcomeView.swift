
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
                        HStack {
                            Spacer()
                            Text("Get started")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                                .onTapGesture {
                                    if isUserSignedIn { // Only allow tap if the user is signed in
                                        isWelcomeScreenOver = true
                                        isShowingMain.toggle()
                                        print("ciao")
                                    }
                                }
                            Spacer()
                        }
                        .padding(.bottom, 60)
                        .onTapGesture {
                            isWelcomeScreenOver = true
                            isShowingMain.toggle()
                            print("ciao")
                        }
                    }
                    else {
                    }
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
