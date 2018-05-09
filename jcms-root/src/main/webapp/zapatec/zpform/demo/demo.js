function testErrOutput(objErrors){
	var message = objErrors.generalError + '<br />';
	
	if (objErrors.fieldErrors) {
		for (var ii = 0; ii < objErrors.fieldErrors.length; ii++)
			message += (ii + 1) + ': Field "' + objErrors.fieldErrors[ii].field.name + '" ' + objErrors.fieldErrors[ii].errorMessage + "<br />";
	}
	
	var outputDiv = document.getElementById("errOutput");
	
	if(outputDiv != null){
		outputDiv.innerHTML = message;
		outputDiv.style.display = "block";
	}
}

function myOnSuccess() {
	var outputDiv = document.getElementById("errOutput");
	
	if(outputDiv != null){
		outputDiv.innerHTML = '';//clear error message if any
		outputDiv.style.display = "none";
	}
	
	alert('Success!');
};

function myDebug(message){
	var debugContainer = document.getElementById("debugContainer");
	
	if(debugContainer == null){
		debugContainer = document.createElement("div");
		debugContainer.id = "debugContainer";
		var st = debugContainer.style;
		st.position = "absolute";
		st.top = "0";
		st.right = "0";
		st.width = "500px";
		st.height = "100px";
		st.overflow = "scroll";
		st.backgroundColor = "#EEEEEE";
		st.fontSize = "small";
		document.body.appendChild(debugContainer);
		Zapatec.ScrollWithWindow.register(debugContainer);
	}

	debugContainer.innerHTML += message.replace(/&/g, '&amp;').replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\n/g, "<br />") + "<br />";
}

function checkIfLoadedFromHDD(){
	if(document.location.toString().indexOf('http') != 0) {
		alert('Since this example demonstrates interaction between server and javascript application, it must be loaded from server. This example does not work if opened from local hard drive.');
	}
}