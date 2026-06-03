import SwiftUI

struct ClientAppointmentsView: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var data: DataService

    var myAppointments: [Appointment] {
        guard let uid = auth.currentUser?.id else { return [] }
        return data.appointments(for: uid).sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            Group {
                if myAppointments.isEmpty {
                    ContentUnavailableView("No Appointments", systemImage: "calendar.badge.plus", description: Text("Your realtor will schedule viewings for you."))
                } else {
                    List(myAppointments) { appointment in
                        AppointmentRow(appointment: appointment)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("My Appointments")
        }
    }
}

struct AppointmentRow: View {
    let appointment: Appointment

    var statusColor: Color {
        switch appointment.status {
        case .confirmed: return .brandTeal
        case .pending:   return .brandGold
        case .cancelled: return .brandRed
        case .completed: return .secondary
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(appointment.listingAddress)
                    .font(.headline)
                Spacer()
                Label(appointment.status.rawValue, systemImage: "circle.fill")
                    .font(.caption)
                    .foregroundStyle(statusColor)
                    .labelStyle(TrailingIconLabelStyle())
            }
            Label(appointment.date.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if !appointment.notes.isEmpty {
                Text(appointment.notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.title
            configuration.icon
        }
    }
}
