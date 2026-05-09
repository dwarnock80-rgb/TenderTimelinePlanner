import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color(hex: "F7F6F2").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 26) {
                    AboutHeaderView()

                    InfoCard {
                        Text("About this app")
                            .cardTitle()

                        Text("The Tender Timeline Planner helps procurement professionals plan and manage their procurement timelines with clarity and control.")
                            .bodyText()

                        Text("It automatically calculates dates based on your chosen start date, adjusting for UK bank holidays and weekends. The Standstill Period uses working days only, while all other stages use calendar days with end-date adjustments.")
                            .bodyText()
                    }

                    InfoCard {
                        Text("How it works")
                            .cardTitle()

                        HowItWorksRow(number: "1", text: "Enter a project name and start date")
                        HowItWorksRow(number: "2", text: "Choose a template with pre-defined stages")
                        HowItWorksRow(number: "3", text: "Customise steps, durations, and add new stages")
                        HowItWorksRow(number: "4", text: "Export your timeline as CSV for sharing")
                    }

                    InfoCard {
                        Text("Date calculations")
                            .cardTitle()

                        Text("Most steps use calendar days. If a step's end date falls on a UK bank holiday or weekend, it is automatically extended to the next working day.")
                            .bodyText()

                        Text("The Standstill period uses working days only, excluding weekends and UK bank holidays entirely.")
                            .bodyText()
                    }
                }
                .padding(.bottom, 120)
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}

struct AboutHeaderView: View {
    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "triangle")
                .font(.system(size: 36, weight: .medium))
                .foregroundColor(Color(hex: "E7AE42"))
                .frame(width: 92, height: 92)
                .overlay(
                    Rectangle()
                        .stroke(Color(hex: "E7AE42"), lineWidth: 4)
                )
                .padding(.top, 70)

            Text("Tender Timeline Planner")
                .font(.system(size: 34, weight: .bold, design: .serif))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 76)
        .background(Color(hex: "0B4543"))
    }
}

struct InfoCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(26)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 14, x: 0, y: 6)
        .padding(.horizontal, 26)
    }
}

struct HowItWorksRow: View {
    let number: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Text(number)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "183A38"))
                .frame(width: 42, height: 42)
                .background(Color(hex: "EBAA2D"))
                .clipShape(Circle())

            Text(text)
                .font(.system(size: 21))
                .foregroundColor(Color(hex: "6E8583"))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

extension Text {
    func cardTitle() -> some View {
        self
            .font(.system(size: 28, weight: .bold, design: .serif))
            .foregroundColor(Color(hex: "183A38"))
    }

    func bodyText() -> some View {
        self
            .font(.system(size: 21))
            .foregroundColor(Color(hex: "6E8583"))
            .lineSpacing(7)
            .fixedSize(horizontal: false, vertical: true)
    }
}
