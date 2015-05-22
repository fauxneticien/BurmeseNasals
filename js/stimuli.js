var carrier_l = 'ငါ';
var carrier_r = 'ကိုရေးနေတယ်';

var words = ['မ', 'မာ', 'မား', 'မတ်',
			 'မှ', 'မှာ', 'မှား', 'မှတ်',
			 'န', 'နာ', 'နား', 'နတ်',
			 'နှ', 'နှာ', 'နှား', 'နှတ်',
			 'ည', 'ညာ', 'ညား', 'ညတ်',
			 'ညှ', 'ညှာ', 'ညှား', 'ညှတ်',
			 'င', 'ငါ', 'ငါး', 'ငတ်',
			 'ငှ','ငှါ', 'ငှါး', 'ငှတ်'];

var genSentence = function(index, type) {
	var sentence;

	if(type == 0) {
		// citation
		sentence = 'အ' + words[index];
	} else if (type == 1) {
		// with carrier sentence
		sentence = carrier_l + words[index] + carrier_r;
	} else {
		// unknown type
		console.log("Type unknown!");
	}

	return sentence;
}