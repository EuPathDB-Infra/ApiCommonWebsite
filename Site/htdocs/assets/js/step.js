var openDetail = null;
var isInsert = "";

$("#diagram").ready(function(){
	$("div.diagram:first div.venn:last span.resultCount a").click();
});

function showDetails(det){
	openDetail = $(det).parent().find("div.crumb_details");
	var parent = openDetail.parent(); // for boolean details, parent is step div
	if (!parent.is("div")) parent = parent.parent(); // for non-boolean details, grandparent is step div
	var diagram = parent.parent();
	var dId = $(diagram).attr("id").substring(8);
	dId = parseInt(dId);
	var disp = openDetail.attr("disp");
	$("#strategy_results").children("div.crumb_details").each(function(){
		$(this).remove();	
	});
	$("div.crumb_details", diagram).each(function(){
		$(this).attr("disp","0");
	})
	$("a.crumb_name img").attr("src","/assets/images/plus.gif");
	if(disp == "0"){
		openDetail.attr("disp","1");
		var det2 = openDetail.clone();
			det2.addClass("jqDnR");
			det2.find(".crumb_menu").addClass("dragHandle");
			setDraggable(det2, ".dragHandle");
		//	det2.draggable({
		//		handle: '.dragHandle',
		//		containment: 'parent'
		//	});
		l = 361;
		t = -27;
		det2.css({
			left: l + "px",
			top: t + "px",
			display: "block",
			position: "absolute"
		});
	det2.appendTo("#strategy_results");
	if ($(det).hasClass('crumb_name')) $(det).children("img").attr("src","/assets/images/minus.gif");
	}
	else{
		openDetail.attr("disp","0");
	if ($(det).hasClass('crumb_name')) $(det).children("img").attr("src","/assets/images/plus.gif");
	}
}

function hideDetails(det){
	openDetail.attr("disp","0");
	openDetail = null;
	
	$("#strategy_results").children("div.crumb_details").each(function(){
		$(this).remove();	
	});
	$("a.crumb_name img").attr("src","/assets/images/plus.gif");
}

function Edit_Step(ele, questionName, url, hideQuery, hideOp){
	//	hideDetails();
		url = "showQuestion.do?questionFullName=" + questionName + url + "&partial=true";
		closeAll(false);
	//	var link = $(".filter_link");
	//	$(link).css({opacity:0.2});
	//	$(link).attr("href","javascript:void(0)");
		var revisestep = $(ele).attr("id");
		var parts = revisestep.split("|");
		var strat = parts[0];
		current_Front_Strategy_Id = parts[0];
		revisestep = parseInt(parts[1]);
		var operation = parts[2];
		var reviseStepNumber = strat + ":" + revisestep + ":0:0:" + operation;
                var questionUrl = url + "&showParams=false";
		$.ajax({
			url: questionUrl,
			dataType: "html",
			success: function(data){
				d = document.createElement('div');
				qf = document.createElement('div');
				$(qf).attr("id","query_form").addClass("jqDnR");
				$(d).append(qf);
				$("#strategy_results").append($(d).html());
				formatFilterForm(url, data,1,reviseStepNumber, hideQuery, hideOp);
			},
			error: function(data, msg, e){
				alert("ERROR \n "+ msg + "\n" + e
                                      + ". \nReloading this page might solve the problem. \nOtherwise, please contact site support.");
			}
		});
		$(this).parent().parent().hide();
}

function Insert_Step(ele,dt){
	//$(ele).parent().parent().hide();
	var sNumber = $(ele).attr("id");
	sNumber = sNumber.split("|");
	isInsert = sNumber[1];
	current_Front_Strategy_Id = sNumber[0];
	openFilter(dt,sNumber[0],sNumber[1],false);
}
var a_link;
function Rename_Step(ele, strat, stpId){
	a_link = $("#diagram_" + strat + " div#step_" + stpId + "_sub h3 a#stepId_" + stpId, $(ele).parent().parent().parent());
	old_name = $(a_link).parent().find("#fullStepName").text();
	var input = document.createElement('input');
	$(input).attr("id","new_name_box").attr("value",old_name).blur(function(){RenameStep(this,strat,stpId)}).focus(function(){this.select();}).keypress(function(event){checkEnter(this,event)}).attr("size","10");
	$("#diagram_" + strat + " div#step_" + stpId + "_sub h3 a#stepId_" + stpId, $(ele).parent().parent().parent()).replaceWith(input);
	$("#new_name_box").focus();
}


function Expand_Step(ele, url){
	$(ele).parent().parent().hide();
	ExpandStep(url);
}

// Utility Functions


