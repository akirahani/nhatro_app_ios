import SwiftUI

struct MenuSlideView: View {
    @Binding var isSidebarVisible: Bool
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
    var bgColor: Color = Color.white

    var body: some View {
        ZStack {
            GeometryReader { _ in
               
            }
            .background(Color.gray)
            .opacity(isSidebarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
            .onTapGesture {
                isSidebarVisible.toggle()
            }
            content

        }
        .edgesIgnoringSafeArea(.all)
    }

    var content: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .topLeading   ) {
                bgColor
                VStack{
                    
                    HStack{
                        Image("khach-tro")   .frame(alignment: .leading)
                        Text("Khách trọ")
                        Spacer()

                    }.padding(.top,20)
                    
                    HStack{
                        Image("dat-coc")
                            .frame(alignment: .leading)
                        Text("Đặt cọc")
                        Spacer()

                    }.padding(.top,20)
                    
                    HStack{
                        Image("thanh-toan")   .frame(alignment: .leading)
                        Text("Thanh toán")
                        Spacer()

                    }.padding(.top,20)
                    
                    HStack{
                        Image("hop-dong-menu")   .frame(alignment: .leading)
                        Text("Hợp đồng")
                        Spacer()

                    }.padding(.top,20)
                    
                    HStack{
                        Image("ct-nuoc")   .frame(alignment: .leading)
                        Text("Thay công tơ nước")
                        Spacer()

                    }.padding(.top,20)
                    
                    HStack{
                        Image("ct-dien")
                            .frame(alignment: .leading)
                        Text("Thay công tơ điện")
                        Spacer()
                    }.padding(.top,20)
                    
                    HStack{
                        Image("thiet-bi-chuyen")   .frame(alignment: .leading)
                        Text("Quản lí thiết bị")
                        Spacer()
                    }.padding(.top,20)
                }
                .padding(.top, 75)
                .padding(.leading, 15)
                
            }
            .frame(width: sideBarWidth)
            .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
            .animation(.default, value: isSidebarVisible)

            Spacer()
        }
    }
}
