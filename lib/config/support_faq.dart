class SupportFaqItem {
  const SupportFaqItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
}

abstract final class SupportFaq {
  static const items = <SupportFaqItem>[
    SupportFaqItem(
      question: 'Sidee baan u dalban karaa alaabta?',
      answer:
          'Ku dar alaabta gaariga, kadibna taabo Dalbo. Waxaad la xiriiri kartaa iibiyaha taleefanka ama WhatsApp.',
    ),
    SupportFaqItem(
      question: 'App-ku ma u baahan yahay internet?',
      answer:
          'Maya. Suuqa, khayraadka, wararka, iyo talooyinku waxay shaqeeyaan offline. Cimilada kaliya ayaa mararka qaar internet u baahan tahay.',
    ),
    SupportFaqItem(
      question: 'Xagee ka helaa talooyin beeraha?',
      answer:
          'Tag Khayraadka si aad u akhrido maqaallo ku saabsan dalagga, waraabka, bacriminta, iyo wax kale.',
    ),
    SupportFaqItem(
      question: 'Ma jiraan lacag online ah?',
      answer:
          'Maya. Dalabku wuxuu ku dhammaadaa inaad la xiriirto iibiyaha. Lacag online laguma qaado.',
    ),
  ];
}