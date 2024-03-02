const resultList = [
    {lastname: 'bob', firstname: 'xcv', result: '1:34.2'},
    {lastname: 'bobby', firstname: 'wxwc', result: '1:37.2'},
    {lastname: 'bobette', firstname: 'qsd', result: '1:42.2'},
    {lastname: 'alfred', firstname: 'azert', result: '2:34.5'},
    {lastname: 'collins', firstname: 'miguel', result: '3:13.2'},
    {lastname: 'collins', firstname: 'kim', result: '1:15.1'},
];

const resultToNumber = (s) => {
    const [min, sec] = s.split(':');
    return Number(min * 60) + Number(sec);
};

const getMeanOfList = (list) => {
    let total = 0;
    for (const t of list) {
        total += t;
    }

    return total/ list.length;
};

    const listOfResults = [];
        for (const a of resultList) {
            listOfResults.push(resultToNumber(a.result));
}

console.log(listOfResults);
console.log(getMeanOfList(listOfResults));


console.log([1,2,3,4].map((x) => x * 2));
console.log(["aze", "qsd", "wxc"].map(toUpper))