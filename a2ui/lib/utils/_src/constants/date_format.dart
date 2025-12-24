// ignore_for_file: constant_identifier_names

class DateFormatter {
  ///yyyy-MM-ddTHH:mm:ssZ
  static const UTC = "yyyy-MM-ddTHH:mm:ss";
  static const mdyhms = "MM/dd/yyyy hh:mm:ss";

  ///MM/yyyy
  static const MMYYYY = "MM/yyyy";
  static const HHmmDDMMYYYY = "HH:mm - dd/MM/yyyy";
  static const ddMMYYYY = "dd/MM/yyyy";
  static const yyyyMMdd = "yyyy/MM/dd";
  static const YYYYMMDD = "yyyy-MM-dd";
  static const HH_mm_DD_MM_YYYY = "HH_mm_dd_MM_yyyy";

  ///eg: 31/11/2019 08:36
  static const ddMMyyyyHHmm = "dd/MM/yyyy HH:mm";
  static const HHmm = "HH:mm";
  static const HHmmdd = "HH:mm /dd";
  static const hhmma = "hh:mm a";
  static const ddhhmma = "dd hh:mm a";
  static const hhmmass = "hh:mm:ss a";
  static const HHmmss = "HH:mm:ss";
  static const MMddyyyyHHmm = "MM-dd-yyyy HH:mm";
  static const MMMddyyyyHHmm = "MMM-dd-yyyy HH:mm";
  static const MMMddyyyyhhmma = "MMM dd yyyy hh:mm a";
  static const MMMddyyyyhhmmssa = "MMM dd, yyyy hh:mm:ss a";
  static const MMMddyyyy = "MMM dd, yyyy";
  static const MMMyyyy = "MMM yyyy";
  static const MMyyyy = "MM/yyyy";
  static const yyyyMMddTHHmma = "yyyy-MM-dd hh:mm a";
  static const ddMMyyyyTHHmmssa = "dd-MM-yyyy hh:mm:ss a";
  static const MMM_dd = "MMM-dd";
  static const dd = "dd";
  static const E = "E";
  static const EEEE = "EEEE";
  static const MMM = "MMM";
  static const EEEEMMMddyyyy = "EEEE, MMM dd, yyyy";
  static const EEEEMMMMddyyyy = "EEEE, MMMM dd, yyyy";
  static const yyyyMMddhhmm = "yyyy-HH-dd hh:mm";
  static const ddMMMyyyyhhmma = "dd MMM yyyy hh:mm a";
  static const ddMMMyyyy = "dd MMMM, yyyy";
  static const ddMMMMyyyy = "dd MMMM yyyy";
  static const ddMMMyyyyhhmmssa = "dd MMM yyyy hh:mm:ss a";
  static const ddMMyyyyhhmma = "dd/MM/yy : hh:mm a";
  static const MMMMdd = "MMMM dd";
  static const MMMMddyyyy = "MMMM dd, yyyy";
  static const LLL = "LLL";

  ///eg: Tháng 11/2022
  static const LLLLyyyy = "LLLL/yyyy";

  ///eg: Mar 20, 2025
  static const LLLddyyyy = "LLL dd, yyyy";

  ///eg: 08:36 AM - 31/11/2019
  static const hhmmaddMMYYYY = "hh:mm a - dd/MM/YYYY";

  ///eg: 31/11/2019 - 08:36
  static const ddMMYYYYhhmm = "dd/MM/yyyy - HH:mm";

  static const DotDDMMYYYY = "dd.MM.yyyy";
  static const hhmmDDMMYYYY = "HH:mm, dd/MM/yyyy";

  static const ddMM = "dd/MM";

  ///eg: Thứ Tư, 20/11/2020
  static const EEEEddMMyyyy = "EEEE, dd/MM/yyyy";
  static const custom1 = "dd 'tháng' MM, yyyy";
}
