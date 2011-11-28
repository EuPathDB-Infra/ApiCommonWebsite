package org.apidb.apicommon.controller;

import org.apidb.apicommon.model.UserFileUploadException;

import org.apache.log4j.Logger;

import java.io.*;
import java.util.HashMap;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;
import org.json.JSONException;
import org.xml.sax.SAXException;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import org.gusdb.wdk.controller.CConstants;
import org.gusdb.wdk.model.Utilities;
import org.gusdb.wdk.model.jspwrap.UserBean;
import org.gusdb.wdk.model.jspwrap.WdkModelBean;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.WdkUserException;

import org.apidb.apicommon.model.UserFile;
import org.apidb.apicommon.model.UserFileFactory;

public class UserFileUploadAction extends Action {
    
  private Logger logger = Logger.getLogger(UserFileFactory.class);
  private UserFileUploadForm cuForm;
  
  public ActionForward execute(ActionMapping mapping,
                               ActionForm form,
                               HttpServletRequest request,
                               HttpServletResponse response) throws Exception {

    String referer = (String) request.getParameter(CConstants.WDK_REFERER_URL_KEY);
    if (referer == null) referer = request.getHeader("referer");

    int index = referer.lastIndexOf("/");
    referer = referer.substring(index);
    ActionForward forward = new ActionForward(referer, false);

    cuForm = (UserFileUploadForm)form;
    HashMap<Integer, Object> formSet = cuForm.getFormFiles();
    HashMap<Integer, String> noteSet = cuForm.getFormNotes();

    for(Integer i : formSet.keySet()) {
      FormFile formFile = (FormFile) formSet.get(i);

      if (formFile == null) continue;
      
      String notes       = noteSet.get(i).trim();
      String title       = cuForm.getTitle().trim();
      String contentType = formFile.getContentType();
      String fileName    = formFile.getFileName();
      byte[] fileData    = formFile.getFileData();

      UserBean user = (UserBean) request.getSession().getAttribute(
              CConstants.WDK_USER_KEY);
      if (user == null || user.isGuest()) {
          return forward;
      }
      WdkModelBean wdkModel = (WdkModelBean) getServlet().getServletContext().getAttribute(
              CConstants.WDK_MODEL_KEY);


      String email = user.getEmail().trim().toLowerCase();
      String userUID = user.getSignature().trim();
      String projectName = wdkModel.getDisplayName();
      String projectVersion = wdkModel.getVersion();        

      UserFile userFile = new UserFile(userUID);
      userFile.setFileName(fileName);
      userFile.setFileData(fileData);
      userFile.setContentType(contentType);
      userFile.setEmail(email);
      userFile.setUserUID(userUID);
      userFile.setTitle(title);
      userFile.setNotes(notes);
      userFile.setProjectName(projectName);
      userFile.setProjectVersion(projectVersion);

      getUserFileFactory().addUserFile(userFile);
      
      logger.debug("contentType " + userFile.getContentType());
      logger.debug("fileName " + userFile.getFileName());
      logger.debug("notes " + userFile.getNotes());
      logger.debug("owner " + email);
      logger.debug("ownerUID " + userFile.getUserUID());
      logger.debug("projectName " + userFile.getProjectName());
      logger.debug("projectVersion " + userFile.getProjectVersion());
      
    }
    return new ActionForward("/communityUploadResult.jsp",true);
  }

  protected UserFileFactory getUserFileFactory() throws WdkModelException,
          NoSuchAlgorithmException, ParserConfigurationException,
          TransformerFactoryConfigurationError, TransformerException,
          IOException, SAXException, SQLException, JSONException,
          WdkUserException, InstantiationException, IllegalAccessException,
          ClassNotFoundException {
      UserFileFactory factory = null;
      try {
          factory = UserFileFactory.getInstance();
      } catch (WdkModelException ex) {
          ServletContext application = getServlet().getServletContext();

          String gusHome = application.getRealPath(application.getInitParameter(Utilities.SYSTEM_PROPERTY_GUS_HOME));
          String projectId = application.getInitParameter(Utilities.ARGUMENT_PROJECT_ID);

          UserFileFactory.initialize(gusHome, projectId);
          factory = UserFileFactory.getInstance();
      }
      return factory;
  }

  public void reset(ActionMapping mapping, HttpServletRequest request) {
      cuForm = null;        
  }
}

