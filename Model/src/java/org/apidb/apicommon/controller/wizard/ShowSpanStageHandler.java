package org.apidb.apicommon.controller.wizard;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionServlet;
import org.gusdb.wdk.controller.CConstants;
import org.gusdb.wdk.controller.action.ActionUtility;
import org.gusdb.wdk.controller.action.QuestionForm;
import org.gusdb.wdk.controller.action.ShowQuestionAction;
import org.gusdb.wdk.controller.action.WizardForm;
import org.gusdb.wdk.controller.wizard.StageHandler;
import org.gusdb.wdk.controller.wizard.StageHandlerUtility;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.WdkUserException;
import org.gusdb.wdk.model.jspwrap.AnswerParamBean;
import org.gusdb.wdk.model.jspwrap.ParamBean;
import org.gusdb.wdk.model.jspwrap.QuestionBean;
import org.gusdb.wdk.model.jspwrap.StepBean;
import org.gusdb.wdk.model.jspwrap.WdkModelBean;
import org.json.JSONException;

public abstract class ShowSpanStageHandler implements StageHandler {

    private static final String ATTR_IMPORT_STEP = "importStep";
    private static final String ATTR_ENABLE_OUTPUT = "enableOuput";

    private static final String SPAN_QUESTION = CConstants.WDK_QUESTION_KEY;

    private static final Logger logger = Logger.getLogger(SpanFromQuestionStageHandler.class);

    protected abstract StepBean getChildStep(ActionServlet servlet,
            HttpServletRequest request, HttpServletResponse response,
            WizardForm wizardForm) throws Exception;

    public Map<String, Object> execute(ActionServlet servlet,
            HttpServletRequest request, HttpServletResponse response,
            WizardForm wizardForm) throws Exception {
        logger.debug("Entering SpanFromQuestionStageHandler....");

        // get child step
        StepBean childStep = getChildStep(servlet, request, response,
                wizardForm);

        // get a span logic question
        WdkModelBean wdkModel = ActionUtility.getWdkModel(servlet);
        String spanQuestionName = ProcessSpanStageHandler.getSpanQuestion(childStep.getType());
        QuestionBean spanQuestion = wdkModel.getQuestion(spanQuestionName);

        // initialize the wizardForm so that it has the param information
        QuestionForm questionForm = new QuestionForm();
        questionForm.setQuestion(spanQuestion);
        questionForm.setServlet(servlet);
        ShowQuestionAction.prepareQuestionForm(spanQuestion, servlet, request,
                questionForm);
        wizardForm.copyFrom(questionForm);

        Map<String, Object> attributes = new HashMap<String, Object>();
        attributes.put(ATTR_IMPORT_STEP, childStep);
        attributes.put(SPAN_QUESTION, spanQuestion);

        // determine the previous step
        String action = wizardForm.getAction();
        if (action.equals(WizardForm.ACTION_ADD)) {
            prepareAdd(servlet, request, wizardForm, childStep, attributes);
        } else if (action.equals(WizardForm.ACTION_INSERT)) {
            prepareInsert(servlet, request, wizardForm, childStep, attributes);
        } else if (action.equals(WizardForm.ACTION_REVISE)) {
            prepareRevise(servlet, request, wizardForm, childStep, attributes);
        } else {
            throw new WdkUserException("Unknown wizard action: " + action);
        }

        logger.debug("Leaving SpanFromQuestionStageHandler....");
        return attributes;
    }

    private void prepareInsert(ActionServlet servlet,
            HttpServletRequest request, WizardForm wizardForm,
            StepBean childStep, Map<String, Object> attributes)
            throws NumberFormatException, NoSuchAlgorithmException,
            WdkModelException, WdkUserException, JSONException, SQLException {
        StepBean currentStep = StageHandlerUtility.getCurrentStep(request);
        StepBean previousStep, nextStep;
        String nextParam = null;
        if (currentStep.isCombined()) { // insert before a combined step
            previousStep = StageHandlerUtility.getPreviousStep(servlet,
                    request, wizardForm);
            nextStep = currentStep;
            nextParam = currentStep.getPreviousStepParam();
        } else { // insert before the first step
            previousStep = childStep;
            childStep = currentStep;
            nextStep = currentStep.getNextStep();
            if (nextStep == null) {
                nextStep = currentStep.getParentStep();
                if (nextStep != null) nextParam = nextStep.getChildStepParam();
            } else {
                nextParam = nextStep.getPreviousStepParam();
            }
        }
        String enableOutput = enableOutput(previousStep, childStep, nextStep,
                nextParam);
        attributes.put(ATTR_ENABLE_OUTPUT, enableOutput);

        // also set the step ids as the default of the the input params
        wizardForm.setValue("span_a", previousStep.getStepId());
        wizardForm.setValue("span_b", childStep.getStepId());
    }

    private void prepareRevise(ActionServlet servlet,
            HttpServletRequest request, WizardForm wizardForm,
            StepBean childStep, Map<String, Object> attributes)
            throws WdkUserException, WdkModelException, SQLException,
            JSONException {
        StepBean currentStep = StageHandlerUtility.getCurrentStep(request);
        StepBean previousStep = currentStep.getPreviousStep();
        StepBean nextStep = currentStep.getNextStep();
        String nextParam = null;
        if (nextStep == null) {
            nextStep = currentStep.getParentStep();
            if (nextStep != null) nextParam = nextStep.getChildStepParam();
        } else {
            nextParam = nextStep.getPreviousStepParam();
        }

        String enableOutput = enableOutput(previousStep, childStep, nextStep,
                nextParam);
        attributes.put(ATTR_ENABLE_OUTPUT, enableOutput);

        // also set the step ids as the default of the the input params
        wizardForm.setValue("span_a", previousStep.getStepId());
        wizardForm.setValue("span_b", childStep.getStepId());
    }

    private void prepareAdd(ActionServlet servlet, HttpServletRequest request,
            WizardForm wizardForm, StepBean childStep,
            Map<String, Object> attributes) throws NumberFormatException,
            WdkUserException, WdkModelException, NoSuchAlgorithmException,
            JSONException, SQLException {
        StepBean rootStep = StageHandlerUtility.getRootStep(servlet, request,
                wizardForm);
        StepBean previousStep = rootStep;
        StepBean nextStep = rootStep.getNextStep();
        String nextParam = null;
        if (nextStep == null) {
            nextStep = rootStep.getParentStep();
            if (nextStep != null) nextParam = nextStep.getChildStepParam();
        } else {
            nextParam = nextStep.getPreviousStepParam();
        }
        String enableOutput = enableOutput(previousStep, childStep, nextStep,
                nextParam);
        attributes.put(ATTR_ENABLE_OUTPUT, enableOutput);

        // also set the step ids as the default of the the input params
        wizardForm.setValue("span_a", previousStep.getStepId());
        wizardForm.setValue("span_b", childStep.getStepId());
    }

    private String enableOutput(StepBean previousStep, StepBean childStep,
            StepBean nextStep, String nextParam) throws WdkModelException {
        if (nextStep == null) return "ab";

        QuestionBean question = nextStep.getQuestion();
        Map<String, ParamBean> params = question.getParamsMap();
        AnswerParamBean param = (AnswerParamBean) params.get(nextParam);

        String previousType = previousStep.getType();
        String childType = childStep.getType();

        String output = "";
        if (param.allowRecordClass(previousType)) output += "a";
        if (param.allowRecordClass(childType)) output += "b";
        return output;
    }
}
