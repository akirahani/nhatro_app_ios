import SwiftUI

struct QuanLiChung: Identifiable{
    let id: Int
    var image: String
    var text: String
}

var dataChung : [QuanLiChung] = [
    QuanLiChung(id:0 ,image: "dichvu", text: "Dịch vụ"),
    QuanLiChung(id:1 ,image: "khachtro", text: "Khách trọ"),
    QuanLiChung(id:2 ,image: "phongtro", text: "Phòng trọ"),
    QuanLiChung(id:3 ,image: "hopdong", text: "Hợp đồng"),
    QuanLiChung(id:4 ,image: "quytien", text: "Quỹ tiền"),
    QuanLiChung(id:5 ,image: "tiencoc", text: "Tiền cọc"),
    QuanLiChung(id:6 ,image: "tienphong", text: "Tiền phòng"),
    QuanLiChung(id:7 ,image: "uudai", text: "Ưu đãi")
]

var gridItemLayout = [
    GridItem(.flexible(minimum: 60)),
    GridItem(.flexible(minimum: 60)),
    GridItem(.flexible(minimum: 60)),
    GridItem(.flexible(minimum: 60))
]


struct ViewQLC : View{
    @State var page : QuanLiChung?
    
    var body: some View{
        switch page!.id
        {
            case 0:
                DichVuView()
            case 1:
                KhachTroView()
            case 2:
                PhongTroView()
            case 3:
                HopDongView()
            case 4:
                QuyTienView()
            case 5:
                TienCocView()
            case 6:
                TienPhongView()
            case 7:
                UuDaiView()
            default:
                EmptyView()
        }
    }
}


struct HomeFragment: View {
    @State var selectedItem: Int?
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    //below header
                    VStack{
                        // info
                        HStack{
                            Text("Đặng Hoàng Minh").font(.system(size: 16, weight: .bold, design: .default))
                                .textCase(.uppercase)
                            Image("detailnv")
                            Spacer()
                        }.padding(.top, 10)
                            .padding(.leading, 14)
                        
                        // cardview doanh thu
                        HStack{
                            VStack(alignment: .leading, spacing: 0){
                                Text("Doanh thu tháng này").textCase(.uppercase)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#8F8F8F"))
                                
                                Text("68.000.00 VNĐ")
                                    .textCase(.uppercase)
                                    .font(.system(size: 20, weight: .bold))
                            }
                            .padding(.top, 24)
                            .padding(.leading, 6)
                            .padding(.bottom, 13)
                            
                            Spacer()
                            
                            HStack(alignment: .center
                                   , spacing: 0){
                                NavigationLink(destination: ThongKeView()){
                                    Text("Xem chi tiết").font(.system(size: 14))
                                        .foregroundColor(Color(hex: "354B9C"))
                                        .padding(.trailing, 5)
                                    Image("detailthongke")
                                }
                       
                            }.padding(.top, 30)
                                .padding(.trailing, 6)
                            
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.trailing, 14)
                        .padding(.leading, 14)
                        .padding(.bottom,13)
                        .shadow(color: Color.gray, radius:5, x: 0, y: 2)
                    }.background(Color.white)
                        
                    // Quản lí chung
                    VStack{
                        HStack(alignment: .firstTextBaseline, spacing: 0){
                            Image("tieuDeQuanLiChung")
                                .overlay(
                                    Text("Quản lí chung")
                                        .textCase(.uppercase).foregroundColor(Color.white).padding(.leading,14), alignment: .leading )
                            Spacer()
                        }
                        

                        LazyVGrid(columns: gridItemLayout, spacing: 5){
                            ForEach(dataChung, id: \.id){ Chung in
                                VStack{
                                    Image("\(Chung.image)").padding(.top,14)
                                    Text("\(Chung.text)").foregroundColor(Color(hex: "354B9C"))
                                        .padding(.bottom,14)
                                }.background(NavigationLink(destination: ViewQLC(page: Chung), tag: Chung.id, selection: $selectedItem) {
                                          EmptyView()
                                      }).onTapGesture {
                                          selectedItem = Chung.id
                                      }
                            }
                        }
                    }
                    .background(Color.white)
                        
                    // Khoản Thu
                    VStack{
                        HStack(alignment: .firstTextBaseline, spacing: 0){
                            Image("tieuDeQuanLiChung")
                                .overlay(
                                    Text("Các khoản thu")
                                        .textCase(.uppercase).foregroundColor(Color.white).padding(.leading,14), alignment: .leading )
                                .padding(.top,13)
                                .padding(.bottom,10)
                            Spacer()
                        }
                    }
                    
                    // danh sách thu
                    HStack{
                        VStack{
                            HStack{
                                Image("tiennuoc")
                                Text("Tiền nước")
                                Spacer()
                                
                            }.frame(maxWidth: .infinity, maxHeight: 51)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 14)
                            Divider()
                            HStack{
                                Image("tiendien")
                                Text("Tiền điện")
                                Spacer()
                            }.frame(maxWidth: .infinity, maxHeight: 51)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 14)
                            Divider()
                            
                            NavigationLink(destination: ThuKhacView()){
                                HStack{
                                    Image("thukhac")
                                    Text("Thu khác").foregroundColor(Color.black)
                                    Spacer()
                                }.frame(maxWidth: .infinity, maxHeight: 51)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .padding(.leading, 14)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.white, radius:5, x: 0, y: 0)
                    .padding(.leading, 14)
                    .padding(.trailing, 14)
                    
                    // khoản Chi
                    HStack(alignment: .firstTextBaseline, spacing: 0){
                        Image("tieuDeQuanLiChung")
                            .overlay(                            Text("Các khoản chi")
                                .textCase(.uppercase).foregroundColor(Color.white).padding(.leading,14), alignment: .leading )
                            .padding(.top,13)
                            .padding(.bottom,10)
                        Spacer()
                    }
                        
                    // Danh sách khoản chi
                    HStack{
                        VStack{
                            HStack{
                                Image("khabien")
                                Text("Chi phí khả biến")
                                Spacer()
                                
                            }.frame(maxWidth: .infinity, maxHeight: 51)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 14)
                            Divider()
                            HStack{
                                Image("batbien")
                                Text("Chi phí bất biến")
                                Spacer()
                            }.frame(maxWidth: .infinity, maxHeight: 51)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 14)
                            Divider()
                            
                            HStack{
                                Image("chikhac")
                                Text("Chi khác")
                                Spacer()
                            }.frame(maxWidth: .infinity, maxHeight: 51)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 14)
                        }
                    }.background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.white, radius:5, x: 0, y: 0)
                        .padding(.leading, 14)
                        .padding(.trailing, 14)
                        .padding(.bottom, 12)

                }
            }
            .background(Color(hex: "#F2F1F6"))
        }
    }
}

struct HomeFragment_Previews: PreviewProvider {
    static var previews: some View {
        HomeFragment()
    }
}
