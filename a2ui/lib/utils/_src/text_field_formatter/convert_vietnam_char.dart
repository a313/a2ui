abstract class ConvertVietnamCore {
  static const _vietnamese = 'aAeEoOuUiIdDyY';
  static final _vietnameseRegex = <RegExp>[
    RegExp('à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
    RegExp('À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
    RegExp('è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
    RegExp('È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
    RegExp('ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
    RegExp('Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
    RegExp('ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
    RegExp('Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
    RegExp('ì|í|ị|ỉ|ĩ'),
    RegExp('Ì|Í|Ị|Ỉ|Ĩ'),
    RegExp('đ'),
    RegExp('Đ'),
    RegExp('ỳ|ý|ỵ|ỷ|ỹ'),
    RegExp('Ỳ|Ý|Ỵ|Ỷ|Ỹ')
  ];

  static String unsign(String text) {
    var result = text;
    for (var i = 0; i < _vietnamese.length; ++i) {
      result = result.replaceAll(_vietnameseRegex[i], _vietnamese[i]);
    }

    return result;
  }
}
