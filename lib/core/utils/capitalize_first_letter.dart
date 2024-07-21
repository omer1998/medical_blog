String capitalizeFirstLetter(String input) {
  var wordList = input.split(" ");
  wordList = wordList
      .map((word) => word.isNotEmpty ? word.substring(0, 1).toUpperCase() + word.substring(1) : word)
      .toList();
  return wordList.join(" ");
}
