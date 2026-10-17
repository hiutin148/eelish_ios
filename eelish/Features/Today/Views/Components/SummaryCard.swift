import SwiftUI

struct SummaryCard : View {
    var onStudy: () -> Void
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Cards due today")
                            .font(.system(size: 13).weight(.medium))
                            .foregroundStyle(.white)
                            
                        Text("30")
                            .font(.system(size: 42).weight(.heavy))
                            .foregroundStyle(.white)
                            
                    }
                    Spacer()
                    ProgressRing(progress: 0.6, size: 70, color: .white, strokeWidth: 6)
                        .overlay {
                            VStack {
                                Text("15")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primaryForeground)
                                Text("done")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.primaryForeground)
                                
                            }
                        }
                }
                .padding(.bottom, 16)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Due")
                            .font(.system(size: 11))
                            .foregroundStyle(.primaryForeground)
                        Text("24")
                            .font(.system(size: 18).weight(.bold))
                            .foregroundStyle(.primaryForeground)
                            
                    }
                    VStack(alignment: .leading) {
                        Text("New")
                            .font(.system(size: 11))
                            .foregroundStyle(.primaryForeground)
                        Text("6")
                            .font(.system(size: 18).weight(.bold))
                            .foregroundStyle(.primaryForeground)
                            
                    }
                    VStack(alignment: .leading) {
                        Text("Done today")
                            .font(.system(size: 11))
                            .foregroundStyle(.primaryForeground)
                        Text("15")
                            .font(.system(size: 18).weight(.bold))
                            .foregroundStyle(.primaryForeground)
                            
                    }
                }.padding(.bottom, 20)
                Button {
                    onStudy()
                } label: {
                    Text("Start Studying")
                }.buttonStyle(.app(.primary, fullWidth: true))
                    .overlay {
                        RoundedRectangle(cornerRadius: .infinity)
                            .fill(.white.opacity(0.18))
                            .allowsHitTesting(false)
                    }
            }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
             
            VStack {
                HStack {
                    Text("Daily progress")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.7))
                    Spacer()
                    Text("15/30")
                        .font(.system(size: 11).weight(.semibold))
                        .foregroundStyle(.white.opacity(0.8))
                        
                }
                .padding(.bottom, 6)
                ProgressBar(progress: 0.2, size: 4, color: .white)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.black.opacity(0.15))
        }
            .frame(maxWidth: .infinity)
            .background(
                .appPrimary
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.bottom, 16)

    }
}
