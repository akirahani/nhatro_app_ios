import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
struct ThongKeView: View {
    var body: some View {
        ScrollView{
            VStack{
                WebView(url: URL(string: "http://localhost/nhatro/admin/api/thong-ke/doanh-thu-truoc.php")!)
                WebView(url: URL(string: "http://localhost/nhatro/admin/api/thong-ke/do-tuoi.php")!)
                WebView(url: URL(string: "http://localhost/nhatro/admin/api/thong-ke/doanh-thu.php")!)
                WebView(url: URL(string: "http://localhost/nhatro/admin/api/thong-ke/gioi-tinh.php")!)
                WebView(url: URL(string: "http://localhost/nhatro/admin/api/thong-ke/thiet-bi.php")!)
                WebView(url: URL(string: "http://localhost/nhatro/admin/api/thong-ke/tien-thiet-bi.php")!)
                WebView(url: URL(string: "http://localhost/nhatro/admin/api/thong-ke/tinh-thanh.php")!)
                WebView(url: URL(string: "http://localhost/nhatro/admin/api/thong-ke/tong-quan.php")!)
            }
        }
       
    }
}



struct ThongKeView_Previews: PreviewProvider {
    static var previews: some View {
        ThongKeView()
    }
}
