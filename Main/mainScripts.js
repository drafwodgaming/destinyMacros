$(document).ready(function () {
  const buttonContainers = {
    ult: $("#ultButton"),
    interact: $("#interactButton"),
    jump: $("#jumpButton"),
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

  /* ****************** Listener ****************** */
  $(document).on("keydown", handleKeydown);
  $(document).on("keypress", handleKeydown);
  $(document).on("contextmenu", handleContextMenu);
  $(document).on("mousedown", handleMousedown);
  /* ****************** Listener ****************** */

  /* Функция для обновления текста в ячейке */
  function updateKeyText(keyContainer, key) {
    keyContainer.val(key.toUpperCase());
  }

  function transformKey(key, event) {
    if (event.keyCode === 32) return "SPACE";
    if (
      event.originalEvent.location === 3 && // Numeric keypad
      event.originalEvent.getModifierState("NumLock")
    )
      return "Num" + key.slice(-1);
    return russianToEnglishMap[key.toLowerCase()] || key;
  }

  function transformMouseButton(button) {
    if (button === 1) return "MButton";
  }

  /* ****************** Handlers ****************** */
  function handleKeydown(event) {
    if (activeKeyContainer) {
      const transformedKey = transformKey(event.key, event);
      updateKeyText(activeKeyContainer, transformedKey);
    }
  }

  function handleMousedown(event) {
    if (activeKeyContainer) {
      if (event.button === 2) {
        event.preventDefault();
      } else if (event.button !== 0) {
        const transformedKey = transformMouseButton(event.button);
        updateKeyText(activeKeyContainer, transformedKey);
      }
    }
  }
  function handleContextMenu(event) {
    event.preventDefault();
  }
  /* ****************** Handlers ****************** */

  for (let containerKey in buttonContainers) {
    if (buttonContainers.hasOwnProperty(containerKey)) {
      const buttonContainer = buttonContainers[containerKey];
      buttonContainer.on("click", function () {
        activeKeyContainer = buttonContainer;
      });
    }
  }
});
