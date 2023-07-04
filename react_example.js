// There are 12 total buttons
// 6 numbers
// 5 operations
// 1 submit
// Reach the target - 1 star
// Reach the target using all the numbers - 2 stars
// Reach the target using all the numbers in a chain - 3 stars

// Happy path
// Select a number => The number become active
// Select an operation => The operation becomes active
// Select another number => The active number disappears
// The new number changes to the result of the operation
// In chain mode (default) the result is the active number

// Changing numbers or operations
// Select a number
// Click it again to deselect
// Click any other number to make it active
// Clicking the active number while an operation is active deselects both

// Invalid operation
// Selecting a number after the operation is active that...
// results in a negative number
// results in a fraction

// Invalid selection
// Selecting submit before reaching the target
// Selecting an operation when no number is active
import { useState, useMemo, useEffect } from "react";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <Game />
    </div>
  );
}

function Game() {
  const numbers = useMemo(() => generateNumberSet(), []);
  const target = useMemo(() => generateTarget(numbers), [numbers]);
  const [operationStatus, setOperationStatus] = useState({
    firstOperand: null,
    operator: null,
    secondOperand: null,
    result: null
  });
  const [activeNumber, setActiveNumber] = useState(null);

  function handleNumberClick(position) {
    const firstOperand = operationStatus.firstOperand;
    const operator = operationStatus.operator;
    const secondOperand = operationStatus.secondOperand;
    // const positionNumber =
    //   moveHistory.numberSetHistory[moveHistory.currentMove][position];
    const positionNumber = position;

    if (firstOperand === positionNumber) {
      setOperationStatus({
        ...operationStatus,
        firstOperand: null,
        operator: null
      });
    } else if (
      firstOperand === null ||
      (firstOperand !== null && operator === null)
    ) {
      setOperationStatus({
        ...operationStatus,
        firstOperand: positionNumber
      });
    } else if (firstOperand !== null && operator != null) {
      setOperationStatus({
        ...operationStatus,
        secondOperand: positionNumber
      });
    } else {
      setOperationStatus({
        firstOperand: null,
        operator: null,
        secondOperand: null,
        result: null
      });
    }
  }

  useEffect(() => {
    console.log(operationStatus);
  }, [operationStatus]);

  function handleOperatorClick(selectedOperator) {
    const firstOperand = operationStatus.firstOperand;
    const operator = operationStatus.operator;
    const secondOperand = operationStatus.secondOperand;
    // const positionNumber =
    //   moveHistory.numberSetHistory[moveHistory.currentMove][position];

    if (firstOperand === null) {
      setOperationStatus({
        firstOperand: null,
        operator: null,
        secondOperand: null,
        result: null
      });
    } else if (firstOperand !== null && operator === null) {
      setOperationStatus({
        ...operationStatus,
        operator: selectedOperator
      });
    } else if (firstOperand !== null && operator === selectedOperator) {
      setOperationStatus({
        ...operationStatus,
        operator: null
      });
    } else {
      setOperationStatus({
        firstOperand: null,
        operator: null,
        secondOperand: null,
        result: null
      });
    }
  }

  function handleUndoClick() {
    setOperationStatus({
      firstOperand: null,
      operator: null,
      secondOperand: null,
      result: null
    });
  }

  let numberSet = {
    position0: 4,
    position1: 6,
    position2: 8,
    position3: 9,
    position4: 11,
    position5: 12
  };
  // moveHistory.numberSetHistory[0]
  let moveHistory = {
    numberSetHistory: [],
    operationTextHistory: [],
    currentMove: 0
  };

  return (
    <div id="main-content">
      <div id="game-content">
        <div id="game">
          <Target value={target} />
          <Numbers numberSet={numbers} onPlay={handleNumberClick} />
          <Operations
            onOperatorClick={handleOperatorClick}
            onUndoClick={handleUndoClick}
          />
          <Submit />
          <NewGame />
        </div>
      </div>
    </div>
  );
}

function Target({ value }) {
  return (
    <div>
      <div id="game-prompt-text">
        Use any combination of numbers to reach the target:
      </div>
      <div id="target-wrapper">
        <div id="target">{value}</div>
      </div>
    </div>
  );
}

function Numbers({ numberSet, onPlay }) {
  return (
    <div id="numbers">
      <Number
        value={numberSet[0]}
        className="number"
        position="number-pos-0"
        onNumberClick={() => onPlay(numberSet[0])}
      />
      <Number
        value={numberSet[1]}
        className="number"
        position="number-pos-1"
        onNumberClick={() => onPlay(numberSet[1])}
      />
      <Number
        value={numberSet[2]}
        className="number"
        position="number-pos-2"
        onNumberClick={() => onPlay(numberSet[2])}
      />
      <Number
        value={numberSet[3]}
        className="number"
        position="number-pos-3"
        onNumberClick={() => onPlay(numberSet[3])}
      />
      <Number
        value={numberSet[4]}
        className="number"
        position="number-pos-4"
        onNumberClick={() => onPlay(numberSet[4])}
      />
      <Number
        value={numberSet[5]}
        className="number"
        position="number-pos-5"
        onNumberClick={() => onPlay(numberSet[5])}
      />
    </div>
  );
}

function Number({ value, onNumberClick, className, position }) {
  return (
    <div className={className} id={position} onClick={onNumberClick}>
      {value}
    </div>
  );
}

function Operations({ onOperatorClick, onUndoClick }) {
  return (
    <div id="operations">
      <button id="undo" aria-label="undo" onClick={() => onUndoClick}>
        <Undo />
      </button>
      <button
        className="operation"
        id="+"
        aria-label="add"
        onClick={() => onOperatorClick("+")}
      >
        <Operation value="+" />
      </button>
      <button
        className="operation"
        id="-"
        aria-label="subtract"
        onClick={() => onOperatorClick("-")}
      >
        <Operation value="-" />
      </button>
      <button
        className="operation"
        id="×"
        aria-label="multiply"
        onClick={() => onOperatorClick("×")}
      >
        <Operation value="×" />
      </button>
      <button
        className="operation"
        id="÷"
        aria-label="divide"
        onClick={() => onOperatorClick("÷")}
      >
        <Operation value="÷" />
      </button>
    </div>
  );
}

function Operation({ value }) {
  // <span class="icon-add">+</span>
  return <span>{value}</span>;
}

function Undo() {
  return <span>!</span>;
}

function Submit() {
  return (
    <div id="submit-and-share-buttons">
      <div id="submit-button" className="oblong-button">
        Submit
      </div>
    </div>
  );
}

function NewGame() {
  return (
    <div id="submit-and-share-buttons">
      <div id="submit-button" className="oblong-button">
        New Game
      </div>
    </div>
  );
}

function getRandomIntInclusive(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1) + min); // The maximum is inclusive and the minimum is inclusive
}

function generateNumberSet() {
  let result = [];
  while (result.length < 6) {
    const randomInt = getRandomIntInclusive(1, 15);
    if (!result.includes(randomInt)) {
      result.push(randomInt);
    }
  }
  result.sort(function (a, b) {
    return a - b;
  });
  return result;
  // return [5, 2, 25, 10, 4, 1];
}

function generateTarget(numberSet) {
  const randomNumberSet = shuffle(numberSet.slice());
  console.log(randomNumberSet);

  let currentTarget = randomNumberSet[0];

  let solution = [];

  for (let index = 0; index < randomNumberSet.length - 1; index++) {
    let operation = performOperation(currentTarget, randomNumberSet[index + 1]);
    let newTarget = operation.result;
    solution.push(operation.operationText);

    while (!(newTarget % 1 === 0) || !(newTarget < 200) || !(newTarget > 0)) {
      operation = performOperation(currentTarget, randomNumberSet[index + 1]);
      newTarget = operation.result;
      solution[solution.length - 1] = operation.operationText;
    }

    currentTarget = newTarget;
  }
  console.log(solution);
  return currentTarget;
}

function shuffle(array) {
  return array.sort(() => Math.random() - 0.5);
}

function performOperation(num1, num2) {
  const operations = [
    { operator: "+", operation: (a, b) => a + b },
    { operator: "-", operation: (a, b) => a - b },
    { operator: "×", operation: (a, b) => a * b },
    { operator: "÷", operation: (a, b) => a / b },
    { operator: "÷", operation: (a, b) => a / b },
    { operator: "÷", operation: (a, b) => a / b },
    { operator: "÷", operation: (a, b) => a / b },
    { operator: "÷", operation: (a, b) => a / b }
  ];

  const randomIndex = Math.floor(Math.random() * operations.length);
  const result = operations[randomIndex].operation(num1, num2);
  const operationText = `${num1} ${operations[randomIndex].operator} ${num2} = ${result}`;

  return { result: result, operationText: operationText };
}
/*
[4, 6, 8, 9, 11, 12]
generating the numberset will store the set in an associative object for the game history
history = {
  0: { numberSet }
}

numberSet = { 
  position0: 4,
  position1: 6,
  position2: 8,
  position3: 9,
  position4: 11,
  position5: 12,
}

clicking on any of the positions or operators will attempt to store it in a special object
the object can store 3 "clicked" items, but here are the rules

add in what undo should do for each step along the way
track where you are in the history of the numberset or game
- if the first item is an operator, start over
- if the first item is a number, store
- if the second item is the same number, clear the first item and start over
- if the second item is a different number, replace the first item
- if the second item is an operator, store
- if the third item is the same operator, clear the second item
- if the third item is a different operator, replace the second item
- if the third item is the same number as the first item, clear and start over
- if the third item is a different number, attempt the operation
- if the operation is negative or fractional, clear the second and third items
- if the operation is successful, the third item position becomes the result
  - and the first item position is cleared
- the numberset in history is updated accordingly

undo behavior:
- if you are at move 0 in history
  - undo only deselects operators
- if you are at move > 0 in history
  - undo goes back to the previous move in history, keeping the first item selected
  - any second or third moves are deselected





*/
