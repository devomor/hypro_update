class GameData {
  final String minBetAmount;
  final String maxBetAmount;
  final String winAmountMultiplyNumber;
  final String gameActive;

  GameData({
    required this.minBetAmount,
    required this.maxBetAmount,
    required this.winAmountMultiplyNumber,
    required this.gameActive,
  });

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      minBetAmount: json['min_bet_amount'] as String,
      maxBetAmount: json['max_bet_amount'] as String,
      winAmountMultiplyNumber: json['win_amount_multiply_number'] as String,
      gameActive: json['game_active'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_bet_amount': minBetAmount,
      'max_bet_amount': maxBetAmount,
      'win_amount_multiply_number': winAmountMultiplyNumber,
      'game_active': gameActive,
    };
  }
}
