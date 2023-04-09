import SwiftUI

struct AccountFragment: View {
    var body: some View {
        ZStack {
            ScrollView{
              Text("Tài khoản")
              Text("Mật khẩu")
              Text("Đăng xuất")
            }
        }
    }
}

struct AccountFragment_Previews: PreviewProvider {
    static var previews: some View {
        AccountFragment()
    }
}
