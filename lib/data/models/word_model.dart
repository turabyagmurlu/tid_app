import 'package:equatable/equatable.dart';

import 'regional_variant_model.dart';

/// Tek bir işaret/kelime. Bölgesel varyantları ve hikayeleştirme (mnemonic)
/// ipucunu, ayrıca mimik gerekliliğini taşır. Bölüm 5 JSON şeması ile uyumlu.
class WordModel extends Equatable {
  final String wordId;
  final String turkishWord;
  final String tidGrammarNote;
  final List<RegionalVariant> regionalVariants;
  final String mnemonicTip;
  final bool facialExpressionRequired;

  /// Gömülü video yoksa, bu işaretin videosuna doğrudan giden bağlantı
  /// (ör. parmak alfabesi harflerinin SpreadTheSign sayfası). Boşsa
  /// genel sözlük araması kullanılır.
  final String dictionaryUrl;

  const WordModel({
    required this.wordId,
    required this.turkishWord,
    required this.tidGrammarNote,
    required this.regionalVariants,
    required this.mnemonicTip,
    required this.facialExpressionRequired,
    this.dictionaryUrl = '',
  });

  factory WordModel.fromMap(Map<String, dynamic> map) {
    final rawVariants = (map['regional_variants'] as List<dynamic>? ?? const []);
    final variants = rawVariants
        .map((e) => RegionalVariant.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
    return WordModel(
      wordId: (map['word_id'] ?? '') as String,
      turkishWord: (map['turkish_word'] ?? '') as String,
      tidGrammarNote: (map['tid_grammar_note'] ?? '') as String,
      regionalVariants: variants,
      mnemonicTip: (map['mnemonic_tip'] ?? '') as String,
      facialExpressionRequired:
          (map['facial_expression_required'] ?? false) as bool,
      dictionaryUrl: (map['dictionary_url'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'word_id': wordId,
        'turkish_word': turkishWord,
        'tid_grammar_note': tidGrammarNote,
        'regional_variants': regionalVariants.map((e) => e.toMap()).toList(),
        'mnemonic_tip': mnemonicTip,
        'facial_expression_required': facialExpressionRequired,
        'dictionary_url': dictionaryUrl,
      };

  @override
  List<Object?> get props => [
        wordId,
        turkishWord,
        tidGrammarNote,
        regionalVariants,
        mnemonicTip,
        facialExpressionRequired,
        dictionaryUrl,
      ];
}
