enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled; // also covers rejected

  String get label => switch (this) {
    BookingStatus.pending => 'Pending',
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.completed => 'Completed',
    BookingStatus.cancelled => 'Cancelled',
  };
}

enum BookingFilter {
  all('All'),
  pending('Pending'),
  confirmed('Confirmed'),
  completed('Completed'),
  cancelled('Cancelled');

  const BookingFilter(this.label);

  final String label;

  bool matches(BookingStatus status) => switch (this) {
    BookingFilter.all => true,
    BookingFilter.pending => status == BookingStatus.pending,
    BookingFilter.confirmed => status == BookingStatus.confirmed,
    BookingFilter.completed => status == BookingStatus.completed,
    BookingFilter.cancelled => status == BookingStatus.cancelled,
  };
}

class BookingUiModel {
  final int id;
  final String studentName;
  final String subject;
  final String dateLabel;
  final String timeLabel;
  final String price;
  final BookingStatus status;

  const BookingUiModel({
    required this.id,
    required this.studentName,
    required this.subject,
    required this.dateLabel,
    required this.timeLabel,
    required this.price,
    required this.status,
  });
}

const sampleBookings = [
  BookingUiModel(
    id: 1,
    studentName: 'Ahmed Hassan',
    subject: 'Mathematics',
    dateLabel: 'Sun, 15 Nov 2026',
    timeLabel: '9:00 AM - 10:00 AM',
    price: 'QAR 120',
    status: BookingStatus.pending,
  ),
  BookingUiModel(
    id: 2,
    studentName: 'Sara Mohammed',
    subject: 'Physics',
    dateLabel: 'Sun, 15 Nov 2026',
    timeLabel: '11:00 AM - 12:00 PM',
    price: 'QAR 150',
    status: BookingStatus.confirmed,
  ),
  BookingUiModel(
    id: 3,
    studentName: 'Omar Khalid',
    subject: 'Arabic',
    dateLabel: 'Mon, 16 Nov 2026',
    timeLabel: '4:00 PM - 5:00 PM',
    price: 'QAR 100',
    status: BookingStatus.pending,
  ),
  BookingUiModel(
    id: 4,
    studentName: 'Layla Ibrahim',
    subject: 'English',
    dateLabel: 'Tue, 10 Nov 2026',
    timeLabel: '5:00 PM - 6:00 PM',
    price: 'QAR 110',
    status: BookingStatus.completed,
  ),
  BookingUiModel(
    id: 5,
    studentName: 'Yousef Ali',
    subject: 'Chemistry',
    dateLabel: 'Mon, 9 Nov 2026',
    timeLabel: '3:00 PM - 4:00 PM',
    price: 'QAR 140',
    status: BookingStatus.completed,
  ),
  BookingUiModel(
    id: 6,
    studentName: 'Noor Saleh',
    subject: 'Biology',
    dateLabel: 'Sat, 7 Nov 2026',
    timeLabel: '10:00 AM - 11:00 AM',
    price: 'QAR 130',
    status: BookingStatus.cancelled,
  ),
  BookingUiModel(
    id: 7,
    studentName: 'Hamad Fahad',
    subject: 'Mathematics',
    dateLabel: 'Wed, 18 Nov 2026',
    timeLabel: '6:00 PM - 7:00 PM',
    price: 'QAR 120',
    status: BookingStatus.confirmed,
  ),
];