
function closeAll(){openFilter();}
var _action = "";
function formatFilterForm(data, edit, reviseStep){
	//edit = 0 ::: adding a new step
	//edit = 1 ::: editing a current step
				var operation = "";
				var stepn = 0;
				if(reviseStep != ""){
					var parts = reviseStep.split(":");
					//stepn = parts[1];
					reviseStep = parseInt(parts[0]);
					isSub = true;//parts[2];
					operation = parts[3];
				}
				var proto = $("#proto").text();
				var lastStepId = $("#last_step_id").text();
				var pro_url = "";
			if(edit == 0)
				pro_url = "processFilter.do?strategy=" + proto;
			else{
				
				pro_url = "processFilter.do?strategy=" + proto + "&revise=" + reviseStep;// + "&step=" + stepn + "&subquery="; + isSub;
			}
				var historyId = $("#history_id").val();
				var stepNum = $("#target_step").val();
				stepNum = parseInt(stepNum) + 1;
				var prev_stepNum = stepNum - 1;
				
			if(edit == 0){
				var close_link = "<a id='close_filter_query' href='javascript:closeAll()'><img src='/assets/images/Close-X-box.png'/></a>";
				var back_link = "<a id='back_to_selection' href='javascript:close()'><img src='/assets/images/backbox.png'/></a>";
	 		}else
				var close_link = "<a id='close_filter_query' href='javascript:closeAll()'><img src='/assets/images/Close-X-box.png'/></a>";
				var quesTitle = $("h1",data).text().replace(/Identify Genes based on/,"");
				var quesForm = $("form#form_question",data);


				$("input[value=Get Answer]",quesForm).val("Run Step");
				$("input[value=Run Step]",quesForm).attr("id","executeStepButton");
				$("div:last",quesForm).attr("align", "");
				$("div:last",quesForm).attr("style", "float:left;margin: 45px 0 0 1%;");

                                $("table:first", quesForm).wrap("<div class='filter params'></div>");
				$("table:first", quesForm).attr("style", "margin-top:15px;");

				// Bring in the advanced params, if exist, and remove styling
				var advanced = $("#advancedParams_link",quesForm);
				advanced = advanced.parent();
				advanced.remove();
				advanced.attr("style", "");
				$(".filter.params", quesForm).append(advanced);
			if(edit == 0)
				$(".filter.params", quesForm).prepend("<span class='form_subtitle'>Add&nbsp;Step&nbsp;" + stepNum + ": " + quesTitle + "</span></br>");
			else
				$(".filter.params", quesForm).prepend("<span class='form_subtitle'>Edit&nbsp;Step&nbsp;" + (reviseStep + 1) + ": " + quesTitle + "</span></br>");
				//$(".filter.params", quesForm).prepend("<span class='form_subtitle'>" + quesTitle + "</span><br>"); 
			if(edit == 0){
				$(".filter.params", quesForm).after("<div class='filter operators'><span class='form_subtitle'>Combine Step " + prev_stepNum + " with Step " + stepNum + "</span><div id='operations'><ul><li class='opcheck'><input type='radio' name='myProp(booleanExpression)' value='" + lastStepId + " AND' checked='checked'/><li class='operation INTERSECT'/><li>&nbsp;" + prev_stepNum + "&nbsp;<b>INTERSECT</b>&nbsp;" + stepNum + "</li><li class='opcheck'><input type='radio' name='myProp(booleanExpression)' value='" + lastStepId + " OR'><li class='operation UNION'/><li>&nbsp;" + prev_stepNum + "&nbsp;<b>UNION</b>&nbsp;" + stepNum + "</li><li class='opcheck'><input type='radio' name='myProp(booleanExpression)' value='" + lastStepId + " NOT'></li><li class='operation MINUS'/><li>&nbsp;" + prev_stepNum + "&nbsp;<b>MINUS</b>&nbsp;" + stepNum + "</li></ul></div></div>");
			}
			else {
				if(reviseStep != 0){
					$(".filter.params", quesForm).after("<div class='filter operators'><span class='form_subtitle'>Combine with Step " + (reviseStep) + "</span><div id='operations'><ul><li class='opcheck'><input id='INTERSECT' type='radio' name='myProp(booleanExpression)' value='" + lastStepId + " AND' checked='checked'/><li class='operation INTERSECT'/><li>&nbsp;" + (reviseStep) + "&nbsp;<b>INTERSECT</b>&nbsp;" + (reviseStep + 1) + "</li><li class='opcheck'><input id='UNION' type='radio' name='myProp(booleanExpression)' value='" + lastStepId + " OR'><li class='operation UNION'/><li>&nbsp;" + (reviseStep) + "&nbsp;<b>UNION</b>&nbsp;" + (reviseStep + 1) + "</li><li class='opcheck'><input id='MINUS' type='radio' name='myProp(booleanExpression)' value='" + lastStepId + " NOT'></li><li class='operation MINUS'/><li>&nbsp;" + (reviseStep) + "&nbsp;<b>MINUS</b>&nbsp;" + (reviseStep + 1) + "</li></ul></div></div>");
				}else{
					$(".filter.params", quesForm).after("<input type='hidden' name='myProp(booleanExpression)' value='" + proto + " AND' />");
				}
			}
				
			//	var action = quesForm.attr("action").replace(/processQuestion.do/,pro_url);
			//	_action = action;
			if(edit == 0)	
				var action = "javascript:AddStepToStrategy('" + pro_url + "')";
			else
				var action = "javascript:EditStep('" + pro_url + "', " + parseInt(revisestep) + ")";


			//	quesForm.prepend("<hr style='width:99%'/>");
				var formtitle = "";
			if(edit == 0)
				formtitle = "<h1>Add&nbsp;Step</h1>"//quesForm.prepend("<h1>Add&nbsp;Step</h1>");
			else
				formtitle = "<h1>Edit&nbsp;Step</h1>"//quesForm.prepend("<h1>Edit&nbsp;Step</h1>");

				//quesForm.prepend("<h1>Add&nbsp;Step&nbsp;" + (stepNum + 1) + "</h1>");

				quesForm.attr("action",action);
			if(edit == 0)
				var header = "<span class='dragHandle'>" + back_link + " " + formtitle + " " + close_link + "</span>";
			else
				var header = "<span class='dragHandle'>" + formtitle + " " + close_link + "</span>";
			
				$("#query_form").html(header);
				$("#query_form").append(quesForm);
				$("#query_selection").fadeOut("normal");
			//	$("#query_form").css({
			//		top: "337px",
			//		left: "22px"
			//	});
			if(edit == 1)
				$("#query_form div#operations input#" + operation).attr('checked','checked'); 
				
				$("#query_form").jqDrag(".dragHandle");
				$("#query_form").fadeIn("normal");
}

//$(".top_nav ul li a").click(function(){
function getQueryForm(url){	
		$.ajax({
			url: url,
			dataType:"html",
			success: function(data){
				formatFilterForm(data,0,"");
			},
			error: function(data, msg, e){
				alert("ERROR \n "+ msg + "\n" + e);
			}
		});
}


var original_Query_Form_Text;

$(document).ready(function(){

//	$("div.crumb_details").hide();
//	$("#filter_div").hide();
	original_Query_Form_Text = $("#query_form").html();
	
	
	

/*
	$("#filter_link").click(function(){;
		if($(this).text() == "Add Step"){
			$("#filter_div").fadeIn("normal");
			$(this).html("<span>Close [X]</span>"); 
		}else{
			$("#filter_div").fadeOut("normal");
			$("#query_selection").show();
			$("#query_form").hide();
			$(this).html("<span>Add Step</span>"); 
		}
		return false;
	});
*/

	$(".crumb").bind("mouseenter",function(){
		$(".crumb_details",this).fadeIn("fast");
	}).bind("mouseleave",function(){
		$(".crumb_details",this).fadeOut("fast");
	});

//	$(".crumb_details").mouseover(function(){
//		$(this).filter(".crumb_detail").show();
//	}).mouseout(function(){
//		$(this).hide();
//	});
	
}); // End of Ready Function


function openFilter() {
	var link = $("#filter_link");
	if($(link).attr("href") == "javascript:openFilter()"){
//		$("#filter_div").fadeIn("normal");
		$("#query_form").html(original_Query_Form_Text);
		$("#query_form").css({
			top: "337px",
			left: "22px"
		});
		$("#query_form").show("normal");
		$("#query_form").jqDrag(".dragHandle");
		$(link).css({opacity:0.2});//html("<span>Close [X]</span>");
		$(link).attr("href","javascript:void(0)");
	}else{
		//$("#filter_div").fadeOut("normal");
		//$("#query_selection").show();
		$("#query_form").hide();
		$(link).css({opacity:1.0});//html("<span>Add Step</span>"); 
		$(link).attr("href","javascript:openFilter()");
	}
}

function close(){
	$("#query_form").html(original_Query_Form_Text);//fadeOut("normal");
	$("#query_form").jqDrag(".dragHandle");
//	$("#query_selection").fadeIn("normal");
//	$("#instructions").text("Revise your results by adding steps from the list below.");
}


function AddStepToStrategy(act){
	var url = act;	
	var quesForm = $("form[name=questionForm]");
	var inputs = $("input", quesForm);
	var selects = $("select", quesForm);
	var d = "";
	var isFirst = 1;
	for(i=0;i<inputs.length;i++){
	    var name = inputs[i].name;
	    if(inputs[i].type == "checkbox" || inputs[i].type == "radio"){
		var boxType = inputs[i].type;
	    	var tempName = name;
		var tempValue = "";
		while(tempName == name && inputs[i].type == boxType){
		   if(inputs[i].checked == true)
			tempValue = tempValue + "," + inputs[i].value;
		   i++;
		   name = inputs[i].name;
		}
		tempValue = tempValue.substring(1);
		if(d == "")
			d = tempName + "=" + tempValue;
		else
			d = d + "&" + tempName + "=" + tempValue;
		i--;
	    }else{
	      if(inputs[i].type != "submit"){
	    	var value = inputs[i].value;
	    	if(i == 0)
			d = name + "=" + value;
	    	else
			d = d + "&" + name + "=" + value;
	      }
	    }
	    isFirst = 0;
	}
//	if(selects.length > 0){
		for(i=0;i<selects.length;i++){
			var sname = selects[i].name;
			var svalue = selects[i].value;
			if(isFirst == 1)
				d = sname + "=" + svalue;
		    else
				d = d + "&" + sname + "=" + svalue;
		}
	//}
	//else{
	//	var sname = selects.attr("name");
	//	var svalue = selects.attr("value");
	//	if(isFirst == 1)
	//		d = name + "=" + value;
	 //   else
		//	d = d + "&" + name + "=" + value;	
	//}
	

	$.ajax({
		url: url,
		type: "POST",
		dataType:"html",
		data: d,
		beforeSend: function(obj){
				var pro_bar = "<div id='step_progress_bar'>" +
							  "<div class='step' id='graphic_span'>Loading...</div></div>";
				$("#loading_step_div").html(pro_bar).show("fast");
				$("#graphic_span").css({opacity: 0.2});
			  for(i = 0;i<100;i++){
				$("#graphic_span").animate({
					opacity: 1.0
				},1000);
				$("#graphic_span").animate({
					opacity: 0.2
				},1000);
			  }
			},
		success: function(data){
			var new_step_id = $("span#step_id",data).text();
			$("#last_step_id").text(new_step_id);
			var sub_step = $("div:first",data);
			var step = $("div",data)[3];
			var id = $(step).attr("id");
			var stepNumber = $("span.stepNumber",data);
			var sN = parseInt(id.substring(5));
			var prev_step = sN - 1;
			var arrow = "<ul><li>";
			var prev_box = $("div#step_"+prev_step);
			if(prev_step == 0)
				arrow = arrow + "<img class='rightarrow1' src='/assets/images/arrow_chain_right1.png'/></li></ul>";
			else
				arrow = arrow + "<img class='rightarrow2' src='/assets/images/arrow_chain_right2.png'/></li></ul>";	
			$("#loading_step_div").html("").hide("fast");
			prev_box.append(arrow);
			$("div#diagram").append(sub_step);
			$("div#diagram").append($(step));
			$("div#diagram").append(stepNumber);
			$("div#step_"+sN+" a").click();
			$("input#target_step").val(sN+1);
		//	var new_url = $("div#step_"+sN+" a").attr("onclick");
		//	new_url = new_url.substring(16);
		//	NewResults($("div#step_"+sN)[0]);
		},
		error: function(data, msg, e){
			alert("ERROR \n "+ msg + "\n" + e);
		}
	});
	openFilter();
}


