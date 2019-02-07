package org.apidb.apicommon.service.test;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.ws.rs.core.Response;
import javax.ws.rs.core.StreamingOutput;

import org.gusdb.fgputil.IoUtil;
import org.gusdb.fgputil.Timer;
import org.gusdb.fgputil.Tuples.TwoTuple;
import org.gusdb.fgputil.runtime.GusHome;
import org.gusdb.wdk.model.WdkModel;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.question.Question;
import org.gusdb.wdk.model.report.config.StandardConfig;
import org.gusdb.wdk.model.report.config.StandardConfig.StreamStrategy;
import org.gusdb.wdk.service.request.exception.DataValidationException;
import org.gusdb.wdk.service.request.exception.RequestMisformatException;
import org.gusdb.wdk.service.service.AnswerService;
import org.json.JSONException;
import org.json.JSONObject;

public class ReporterStreamingTest {

  private static final int BUFFER_SIZE = 32768;

  public static void main(String[] args) throws Exception {
    if (args.length != 3) {
      System.err.println("\nUSAGE: " + ReporterStreamingTest.class.getSimpleName() + " <project_id> <question_name> <answer_request_json_file>\n");
      System.exit(1);
    }
    String projectId = args[0];
    String questionName = args[1];
    String inputJsonFileName = args[2];
    
    try (FileReader inputFile = new FileReader(inputJsonFileName);
         WdkModel wdkModel = WdkModel.construct(projectId, GusHome.getGusHome())) {
      Question question = wdkModel.getQuestion(questionName)
          .orElseThrow(() -> new WdkModelException("Question " + questionName + " does not exist in this WDK model."));
      log("Parsing input file: " + inputJsonFileName);
      JSONObject answerRequestJson = new JSONObject(IoUtil.readAllChars(inputFile));
      log("Creating answer service");
      AnswerService answerService = new AnswerService(question.getRecordClassName(), question.getFullName());
      answerService.testSetup(wdkModel);
      Path tmpFileDir = IoUtil.createOpenPermsTempDir("wdk_stream_test_");
      TwoTuple<String,Path> pagedAnswerResults = timeResponse(answerService, baseJsonStr, StreamStrategy.PAGED_ANSWER, tmpFileDir);
      TwoTuple<String,Path> fileBasedResults = timeResponse(answerService, baseJsonStr, StreamStrategy.FILE_BASED, tmpFileDir);
      log("Paged Answer time: " + pagedAnswerResults.getFirst() + ", file: " + pagedAnswerResults.getSecond());
      log("File-based time: " + fileBasedResults.getFirst() + ", file: " + fileBasedResults.getSecond());
      log("Done.");
    }
  }

  private static TwoTuple<String,Path> timeResponse(AnswerService answerService,
      String baseJsonStr, StreamStrategy streamStrategy, Path tmpFileDir)
      throws WdkModelException, DataValidationException, JSONException, IOException, RequestMisformatException {
    log("\nBuilding final JSON for " + streamStrategy + " test.");
    JSONObject json = new JSONObject(baseJsonStr);
    JSONObject formatConfig = json.getJSONObject("formatting").getJSONObject("formatConfig");
    formatConfig.put(StandardConfig.STREAM_STRATEGY_JSON, streamStrategy.name());
    log("Starting request using " + streamStrategy);
    Timer t = new Timer();
    Response response = answerService.buildResult(json.toString());
    StreamingOutput output = (StreamingOutput)response.getEntity();
    Path outputFile = Paths.get(tmpFileDir.toString(), streamStrategy + ".txt");
    try (OutputStream fileOutput = new BufferedOutputStream(new FileOutputStream(outputFile.toFile()), BUFFER_SIZE)) {
      output.write(fileOutput);
    }
    String time = t.getElapsedString();
    System.out.println("Output written in " + time + "\n");
    return new TwoTuple<String,Path>(time, outputFile);
  }

  private static void log(Object obj) {
    System.out.println(obj);
  }
}
