var blocks = {
	1 : [27,5,18,7,11,13,32,31,6,1,24,10,3,17,16,14,15,25,26,28,20,22,2,29,21,19,12,8,30,23,9,4],
	2 : [13,3,5,11,30,18,31,26,25,23,29,1,20,15,22,2,8,28,9,4,24,17,21,10,32,12,19,27,6,16,14,7],
	3 : [22,12,30,6,14,7,5,9,23,1,8,28,16,3,13,29,32,2,27,10,24,17,15,20,11,26,21,19,18,25,4,31],
	4 : [14,17,26,18,19,12,29,25,10,2,23,13,21,11,9,16,3,6,1,28,7,27,4,30,20,32,15,8,5,22,31,24],
	5 : [2,21,4,19,28,25,11,22,13,3,6,23,12,16,15,1,17,26,8,18,7,31,9,32,5,14,20,30,24,27,10,29]
};

var makeBlock = function(order, mode, name) {
	var end = 'End of ' + name;

	var stack = [name];

	$.each(order, function(i, v) {
		var sentence = genSentence(v - 1, mode);
		stack.push(sentence);
	});

	stack.push(end);

	return stack;
}