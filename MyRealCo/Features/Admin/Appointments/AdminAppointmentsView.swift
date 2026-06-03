import SwiftUI

struct AdminAppointmentsView: View {
    @EnvironmentObject var data: DataService
    @State private var selectedStatus: Appointment.AppointmentStatus? = nil
    @State private var showSendMessage = false
    @State private var showAddAppointment = false
    @State private var selectedAppointment: Appointment?

    var filtered: [Appointment] {
        let sorted = data.appointments.sorted { $0.date > $1.date }
        guard let status = selectedStatus else { return sorted }
        return sorted.filter { $0.status == status }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterChip(label: "All", isSelected: selectedStatus == nil) {
                            selectedStatus = nil
                        }
                        ForEach(Appointment.AppointmentStatus.allCases, id: \.self) { status in
                            FilterChip(label: status.rawValue, isSelected: selectedStatus == status) {
                                selectedStatus = selectedStatus == status ? nil : status
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .background(Color(.systemGroupedBackground))

                List(filtered) { appointment in
                    AdminAppointmentRow(appointment: appointment) { newStatus in
                        data.updateAppointmentStatus(id: appointment.id, status: newStatus)
                    } onMessage: {
                        selectedAppointment = appointment
                        showSendMessage = true
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            data.deleteAppointment(id: appointment.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Appointments")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAddAppointment = true } label: {
                        Image(systemName: "plus")
                    }
                    .tint(Color.brandTeal)
                }
            }
            .sheet(isPresented: $showAddAppointment) {
                AddAppointmentView()
            }
            .sheet(isPresented: $showSendMessage) {
                if let appt = selectedAppointment {
                    SendMessageView(recipientId: appt.clientId, recipientName: appt.clientName)
                }
            }
        }
    }
}

struct AdminAppointmentRow: View {
    let appointment: Appointment
    let onStatusChange: (Appointment.AppointmentStatus) -> Void
    let onMessage: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(appointment.clientName).font(.headline)
                    Text(appointment.clientEmail).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Menu {
                    ForEach(Appointment.AppointmentStatus.allCases, id: \.self) { status in
                        Button(status.rawValue) {
                            onStatusChange(status)
                        }
                    }
                } label: {
                    StatusBadge(status: appointment.status)
                }
            }

            Label(appointment.listingAddress, systemImage: "mappin")
                .font(.subheadline)
                .foregroundStyle(Color.brandTeal)

            Label(appointment.date.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if !appointment.notes.isEmpty {
                Text("\"\(appointment.notes)\"")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
            }

            Button {
                onMessage()
            } label: {
                Label("Message Client", systemImage: "message")
                    .font(.caption.bold())
            }
            .buttonStyle(.bordered)
            .tint(Color.brandTeal)
        }
        .padding(.vertical, 4)
    }
}

struct StatusBadge: View {
    let status: Appointment.AppointmentStatus

    var color: Color {
        switch status {
        case .confirmed: return .brandTeal
        case .pending:   return .brandGold
        case .cancelled: return .brandRed
        case .completed: return .secondary
        }
    }

    var body: some View {
        Text(status.rawValue)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(isSelected ? Color.brandTeal : Color(.systemGray5))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}
