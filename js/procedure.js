var blocks = {
	1 : [9,20,27,3,6,18,17,8,7,28,12,5,10,26,25,24,1,16,30,14,11,19,2,4,21,29,22,23,15,31,32,13],
	2 : [32,8,1,29,17,20,10,5,7,30,18,9,19,2,6,21,24,4,12,3,25,31,27,13,28,26,16,14,22,11,15,23],
	3 : [15,10,6,25,4,24,27,13,9,20,5,23,26,28,3,12,31,29,30,22,16,2,8,7,18,1,19,14,32,11,17,21],
	4 : [12,26,1,18,24,17,32,3,19,25,2,22,30,9,14,29,15,21,5,7,20,8,11,4,27,10,16,28,6,23,31,13]
};

var makeBlock = function(which, mode) {
	var start = 'Block ' + which;
	var end = 'End of block ' + which;

	var stack = [start];

	$.each(blocks[which], function(i, v) {
		var sentence = genSentence(v - 1, mode);
		stack.push(sentence);
	});

	stack.push(end);

	return stack;
}