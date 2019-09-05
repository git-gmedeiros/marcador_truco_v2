class Player {
  String name;
  int score;
  int victories;

  Player({this.name, this.score, this.victories});

  int addScore(int qtd){
    if(qtd > 0 && score >= 12) return score;
    else if(qtd < 0 && score <= 0 ) return score;
    else score += qtd;
    return score;
  }


}