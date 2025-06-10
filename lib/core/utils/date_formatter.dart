import 'package:intl/intl.dart';

class DateFormatter {
  // تحويل التاريخ من ISO 8601 إلى شكل جميل بالعربية
  static String formatArabicDate(String isoDateString) {
    try {
      // تحويل النص إلى DateTime
      DateTime dateTime = DateTime.parse(isoDateString);

      // تحويل إلى التوقيت المحلي (القاهرة)
      DateTime localDateTime = dateTime.toLocal();

      // أسماء الأشهر بالعربية
      const List<String> arabicMonths = [
        'يناير',
        'فبراير',
        'مارس',
        'إبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];

      // أسماء الأيام بالعربية
      const List<String> arabicDays = [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد'
      ];

      // تنسيق التاريخ
      String day = localDateTime.day.toString();
      String month = arabicMonths[localDateTime.month - 1];
      String year = localDateTime.year.toString();
      String dayName = arabicDays[localDateTime.weekday - 1];

      // تنسيق الوقت
      String hour = localDateTime.hour.toString().padLeft(2, '0');
      String minute = localDateTime.minute.toString().padLeft(2, '0');
      String period = localDateTime.hour >= 12 ? 'مساءً' : 'صباحاً';

      // تحويل إلى نظام 12 ساعة
      int hour12 = localDateTime.hour;
      if (hour12 == 0) {
        hour12 = 12;
      } else if (hour12 > 12) {
        hour12 -= 12;
      }

      return '$dayName، $day $month $year - ${hour12.toString().padLeft(2, '0')}:$minute $period';
    } catch (e) {
      return 'تاريخ غير صحيح';
    }
  }

  // تنسيق مبسط للتاريخ فقط
  static String formatSimpleArabicDate(String isoDateString) {
    try {
      DateTime dateTime = DateTime.parse(isoDateString);
      DateTime localDateTime = dateTime.toLocal();

      const List<String> arabicMonths = [
        'يناير',
        'فبراير',
        'مارس',
        'إبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];

      String day = localDateTime.day.toString();
      String month = arabicMonths[localDateTime.month - 1];
      String year = localDateTime.year.toString();

      return '$day $month $year';
    } catch (e) {
      return 'تاريخ غير صحيح';
    }
  }

  // تنسيق الوقت النسبي (منذ كم من الوقت)
  static String formatRelativeTime(String isoDateString) {
    try {
      DateTime dateTime = DateTime.parse(isoDateString);
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'الآن';
      } else if (difference.inMinutes < 60) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else if (difference.inHours < 24) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} يوم';
      } else if (difference.inDays < 30) {
        int weeks = (difference.inDays / 7).floor();
        return 'منذ $weeks أسبوع';
      } else if (difference.inDays < 365) {
        int months = (difference.inDays / 30).floor();
        return 'منذ $months شهر';
      } else {
        int years = (difference.inDays / 365).floor();
        return 'منذ $years سنة';
      }
    } catch (e) {
      return 'تاريخ غير صحيح';
    }
  }
}
