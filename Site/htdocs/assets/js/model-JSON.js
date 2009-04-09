/**************************************************
Strategy Object and Functions
****************************************************/

function Strategy(frontId, backId, isDisplay){
	this.frontId = frontId;
	this.backId = backId;
	this.isDisplay = isDisplay;
	this.subStratOrder = new Object();
}
Strategy.prototype.checksum = null;
Strategy.prototype.JSON = null;
Strategy.prototype.subStratOf = null;
Strategy.prototype.Steps = new Array();
Strategy.prototype.isSaved = false;
Strategy.prototype.name = null;
Strategy.prototype.savedName = null;
Strategy.prototype.importId = null;
Strategy.prototype.dataType = null;
Strategy.prototype.getStep = function(stepId,isfront){
	for(s in this.Steps){
		if(isfront){
			if(this.Steps[s].frontId == stepId)
				return this.Steps[s];
		}else{
			if(this.Steps[s].back_step_Id == stepId || this.Steps[s].back_boolean_Id == stepId)
				return this.Steps[s];
		}
	}
	return null;
}
Strategy.prototype.depth = function(stepid, d){
	if(this.subStratOf == null)
		return 0;
	var parStrat = this;
	if(stepid == null){
		d = 1;
		ssParts = this.backId.split("_");
		stepid = ssParts[1];
		parStrat = getStrategyFromBackId(ssParts[0]);
	}
	var parStep = parStrat.getStep(stepid, false);
	if(parStep != null){
		return 1;
	}else{
		var subS = getSubStrategies(parStrat.frontId);
		if(subS.length == 0)
			return null;
		for(str in subS){
			r = subS[str].depth(stepid, d);
			if(r != null)
				return d + r;
		}
		
	}
}

Strategy.prototype.initSteps = function(steps){
	var arr = new Array();
	var st = null;
	var stepCount = steps.length;
	for(var i in steps){
		if(i != "length"){
			if(steps[i].isboolean){
				st = new Step(i, steps[i].step.id, steps[i].id, null, steps[i].step.answerId);
				st.operation = steps[i].operation;
				st.isboolean = true;
				if(steps[i].step.isCollapsed && steps[i].step.strategy.order > 0){
					subId = loadModel(steps[i].step);
					this.subStratOrder[steps[i].step.strategy.order] = subId;
					st.child_Strat_Id = subId;
				}
			}else{ 
				st = new Step(i, steps[i].id, "", null, steps[i].answerId);
				if(steps[i].istransform){
					st.isTransform = true;
				}
			}
			if(i == stepCount)
				st.isLast = true;
			if(st.frontId != 1){
				pstp = steps[parseInt(i)-1];
				if(parseInt(i)-1 == 1)
					st.prevStepType = "";
				else 
					st.prevStepType = (pstp.istransform) ? "transform" : "boolean";
			}
			if(!st.isLast){
				nstp = steps[parseInt(i)+1];
				st.nextStepType = (nstp.istransform) ? "transform" : "boolean";
			}
			arr.push(st);
		}
	}
	this.Steps = arr;
}

/****************************************************
Step Object and Functions
****************************************************/

function Step(frontId, back_step_Id, back_boolean_Id, child_Strat_Id, answerId){
	this.frontId = frontId;
	this.back_step_Id = back_step_Id;
	this.back_boolean_Id = back_boolean_Id;
	this.child_Strat_Id = null;
	this.answerId = answerId;
}
Step.prototype.operation = null;
Step.prototype.isboolean = false;
Step.prototype.isSelected = false;
Step.prototype.isTransform = false;
Step.prototype.isFiltered = false;
Step.prototype.isLast = false;
Step.prototype.prevStepType = "";
Step.prototype.nextStepType = "";

/****************************************************
Utility Functions
*****************************************************/
	
function getStep(strat,id){
	for(i=0;i<strats.length;i++){
		if(strats[i].frontId == strat){
			for(j=0;j<strats[i].Steps.length;j++){
				if(strats[i].Steps[j].frontId == id)
					return strats[i].Steps[j];
			}
		}
	}
	return false;
}
	
function getStrategy(id){
	for(i=0;i<strats.length;i++){
		if(strats[i].frontId == id)
			return strats[i];
	}
	return false;
}

function getSubStrategies(id){
	var arr = new Array();
	var pStrat = getStrategy(id);
	//arr.push(pStrat);
/*	for(i=0;i<strats.length;i++){
		if(strats[i].backId.indexOf(pStrat.backId + "_") != -1)
			arr.push(strats[i]);
	}*/
	for(substrt in pStrat.Steps){
		if(pStrat.Steps[substrt].child_Strat_Id != null){
			if(getStrategy(pStrat.Steps[substrt].child_Strat_Id) != false)
				arr.push(getStrategy(pStrat.Steps[substrt].child_Strat_Id));
		}
	}
	return arr;
}

function getStrategyFromBackId(id){
	for(i=0;i<strats.length;i++){
		if(strats[i].backId == id)
			return strats[i];
	}
	return false;
}

function getStepFromBackId(strat,id){
	strategy = getStrategyFromBackId(strat);
	for(j=0;j<strategy.Steps.length;j++){
		if(strategy.Steps[j].back_step_Id == id
		   || strategy.Steps[j].back_boolean_Id == id)
			return strategy.Steps[j];
	}
}

function findStrategy(fId){
	for(i=0;i<strats.length;i++){
		if(strats[i].frontId == fId)
			return i;
	}
	return -1;
}

function findStep(stratId, fId){
	steps = getStrategy(stratId).Steps;
	for(i=0;i<steps.length;i++){
		if(steps[i].frontId == fId)
			return i;
	}
	return -1;
}

function getDataType(cl, sz){
	var s = "s";
	if(sz == 1)
		s = ""
	if(cl == "GeneRecordClasses.GeneRecordClass")
		return "Gene" + s;
	if(cl == "SequenceRecordClasses.SequenceRecordClass")
		return "Sequence" + s;
	if(cl == "EstRecordClasses.EstRecordClass")
		return "EST" + s;
	if(cl == "OrfRecordClasses.OrfRecordClass")
		return "ORF" + s;
	if(cl == "IsolateRecordClasses.IsolateRecordClass")
		return "Isolate" + s;
	if(cl == "SnpRecordClasses.SnpRecordClass")
		return "SNP" + s;
	if(cl == "AssemblyRecordClasses.AssemblyRecordClass"){
		if(s == "") 
			return "Assembly";
		else 
			return "Assemblies";
	}
	if(cl == "SageTagRecordClasses.SageTagRecordClass")
		return "Sage Tag" + s;
}
