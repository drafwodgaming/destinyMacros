const buttonContainers = {
  ult: document.getElementById("ultButton"),
  interact: document.getElementById("interactButton"),
  jump: document.getElementById("jumpButton"),
};
const russianToEnglishMap = {
  й: "Q",
  ц: "W",
  у: "E",
  к: "R",
  е: "T",
  н: "Y",
  г: "U",
  ш: "I",
  щ: "O",
  з: "P",
  х: "[",
  ъ: "]",
  ф: "A",
  ы: "S",
  в: "D",
  а: "F",
  п: "G",
  р: "H",
  о: "J",
  л: "K",
  д: "L",
  ж: ";",
  э: "'",
  ё: "`",
  я: "Z",
  ч: "X",
  с: "C",
  м: "V",
  и: "B",
  т: "N",
  ь: "M",
  б: ",",
  ю: ".",
};

let activeKeyContainer = null;

document.addEventListener("keydown", handleKeydown);
document.addEventListener("keypress", handleKeydown);

// Функция для обновления текста в ячейке
function updateKeyText(keyContainer, key) {
  keyContainer.innerText = key;
}

// Функция для преобразования клавиш
function transformKey(key, event) {
  if (key === "SPACEBAR") {
    return "SPACE";
  } else if (event.location === KeyboardEvent.DOM_KEY_LOCATION_NUMPAD) {
    key = "Num" + key.slice(-1);
  } else if (/[а-яА-ЯЁё]/.test(key)) {
    const lowercaseKey = key.toLowerCase();
    if (lowercaseKey in russianToEnglishMap) {
      return russianToEnglishMap[lowercaseKey];
    }
  }
  return key;
}

function handleKeydown(event) {
  if (activeKeyContainer) {
    const transformedKey = transformKey(event.key.toUpperCase(), event);
    updateKeyText(activeKeyContainer, transformedKey);
  }
}
for (let containerKey in buttonContainers) {
  if (buttonContainers.hasOwnProperty(containerKey)) {
    const buttonContainer = buttonContainers[containerKey];
    buttonContainer.addEventListener("click", function () {
      activeKeyContainer = buttonContainer;
    });
  }
}
