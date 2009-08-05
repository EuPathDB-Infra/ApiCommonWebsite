package org.apidb.apicommon.controller;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;
import org.apidb.apicommon.model.Comment;
import org.apidb.apicommon.model.UserFile;
import org.apidb.apicommon.model.UserFileFactory;
import org.gusdb.wdk.controller.CConstants;
import org.gusdb.wdk.model.Utilities;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.WdkUserException;
import org.gusdb.wdk.model.jspwrap.UserBean;
import org.gusdb.wdk.model.jspwrap.WdkModelBean;
import org.json.JSONException;
import org.xml.sax.SAXException;

public class NewCommentAction extends CommentAction {

    private NewCommentForm cuForm;

    public ActionForward execute(ActionMapping mapping, 
                                 ActionForm form, 
                                 HttpServletRequest request, 
                                 HttpServletResponse response) throws Exception {

        // get comment factory, and initialize it if necessary

        // get the referer link
        String referer = (String) request.getParameter(CConstants.WDK_REFERER_URL_KEY);
        if (referer == null) referer = request.getHeader("referer"); 

        int index = referer.lastIndexOf("/");
        String host = referer.substring(0, index);
        referer = referer.substring(index);
        ActionForward forward = new ActionForward(referer, false);
        // forward.setRedirect(true);

        WdkModelBean wdkModel = (WdkModelBean) getServlet().getServletContext().getAttribute(
                CConstants.WDK_MODEL_KEY);
        // get the current user
        UserBean user = (UserBean) request.getSession().getAttribute(
                CConstants.WDK_USER_KEY);
        // if the user is null or is a guest, fail
        if (user == null || user.isGuest()) {
            // This is the case where the session times out while the user is on
            // the
            // comment form page, or someone maliciously trying to post to the
            // comment form
            // action directly. Return to the add comments page, where it is
            // handled correctly.
            return forward;
        }

        // get all the parameters
        // HTML sanitization need to be enabled only for headline and content.
        //String headline = request.getParameter("headline");
        //if (headline.trim().length() == 0) headline = null;
        //else headline = BBCode.getInstance().convertBBCodeToHtml(headline);

        // test haiming
        cuForm = (NewCommentForm)form;

        String headline = cuForm.getHeadline().trim();
        //headline = BBCode.getInstance().convertBBCodeToHtml(headline);

        //String content = BBCode.getInstance().convertBBCodeToHtml(
         //       request.getParameter("content"));
        String content = cuForm.getContent().trim();
        //content = BBCode.getInstance().convertBBCodeToHtml(content);

        if (headline == null && (content == null || content.length() == 0)) {
            request.setAttribute("submitStatus",
                    "Error: Comment cannot be empty.");
            return forward;
        }

        String commentTarget = cuForm.getCommentTargetId();

        //String[] targetCategoryIds = (String[])request.getParameterValues("targetCategory");
        String[] targetCategoryIds = (String[])cuForm.getTargetCategory();

        String pmIdStr = cuForm.getPmIds();
        String accessionStr = cuForm.getAccessions();
        String associatedStableIdsStr = cuForm.getAssociatedStableIds();
        String stableId = cuForm.getStableId();
        String organism = cuForm.getOrganism();
        String extDbName = cuForm.getExternalDbName();
        String extDbVersion = cuForm.getExternalDbVersion();
        String locType = cuForm.getLocType();
        String coordinateType = null;
        boolean reversed = false;
        if (locType.startsWith("genome")) {
            coordinateType = LOCATION_COORDINATETYPE_GENOME;
            if (locType.endsWith("r")) reversed = true;
        } else coordinateType = LOCATION_COORDINATETYPE_PROTEIN;

        String locations = cuForm.getLocations();
        String email = user.getEmail().trim().toLowerCase();
        int userId = user.getUserId();
        String projectName = wdkModel.getDisplayName();
        String projectVersion = wdkModel.getVersion();

        // create a comment instance
        Comment comment = new Comment(email);
        comment.setCommentTarget(commentTarget);
        comment.setStableId(stableId);
        comment.setProjectName(projectName);
        comment.setProjectVersion(projectVersion);
        comment.setHeadline(headline);
        comment.setOrganism(organism);
        comment.setContent(content);
        comment.setUserId(userId);

        if((targetCategoryIds != null) && (targetCategoryIds.length > 0)) {
          int[] targetCategoryIdArray = new int[targetCategoryIds.length];
          for(int i=0; i < targetCategoryIds.length; i++) {
             targetCategoryIdArray[i] = Integer.valueOf(targetCategoryIds[i]).intValue();
          }
          comment.setTargetCategoryIds(targetCategoryIdArray);
        }

        if((pmIdStr != null) && (pmIdStr.trim().length() != 0)) {
          String[] pmIds = handleDelimiter(pmIdStr).split(" ");
          comment.setPmIds(pmIds);
        }

        if((accessionStr != null) && (accessionStr.trim().length() != 0)) {
          String[] accessions = handleDelimiter(accessionStr).split(" ");
          comment.setAccessions(accessions);
        }

        if((associatedStableIdsStr != null) && (associatedStableIdsStr.trim().length() != 0)) {
          String[] ids = handleDelimiter(associatedStableIdsStr).split(" ");
          comment.setAssociatedStableIds(ids);
        }

        try {
            comment.setLocations(reversed, locations, coordinateType);
        } catch (Exception e) {
            request.setAttribute(
                    "submitStatus",
                    "Error in Location format. "
                            + "Please refer to the format examples on the Add Comment page");
            return forward;
        }
        comment.addExternalDatabase(extDbName, extDbVersion);


        Map<Integer, FormFile> formSet = cuForm.getFormFiles();
        Map<Integer, String> noteSet = cuForm.getFormNotes();

        String userUID = user.getSignature().trim();

        ArrayList<String> files = new ArrayList<String>();

        for(Integer i : formSet.keySet()) {

            FormFile formFile = formSet.get(i);

            if(formFile == null) continue;

            String notes = noteSet.get(i).trim();
            String contentType = formFile.getContentType();
            String fileName   = formFile.getFileName();
            int fileSize       = formFile.getFileSize();
            byte[] fileData    = formFile.getFileData();

            UserFile userFile = new UserFile(userUID);

            userFile.setFileName(fileName); 
            userFile.setFileData(fileData);
            userFile.setContentType(contentType);
            userFile.setFileSize(fileSize);
            userFile.setEmail(email);
            userFile.setUserUID(userUID);
            userFile.setTitle(headline);
            userFile.setNotes(notes);
            userFile.setProjectName(projectName);
            userFile.setProjectVersion(projectVersion);

            getUserFileFactory().addUserFile(userFile);

            int fileId = userFile.getUserFileId();
            String fileStr = fileId + "|" + fileName + "|" + notes;
            files.add(fileStr);

        }

        if(files.size() > 0) {

          String[] f = new String[files.size()];
          comment.setFiles(files.toArray(f));
        }

        // add the comment
        ServletContext context = servlet.getServletContext();
        CommentActionUtility.getCommentFactory(context).addComment(comment);

        String projectId = getServlet().getServletContext().getInitParameter(Utilities.ARGUMENT_PROJECT_ID);
        String link = host + "/showComment.do?projectId=" + projectId + "&stableId=" + stableId + "#" + comment.getCommentId(); 

        StringBuffer body = new StringBuffer();
        if(projectId.equals("PlasmoDB") || projectId.equals("CryptoDB")) { 
          body.append("Thank you! Your comment will be reviewed by a curator shortly.\n");
        } else {
          body.append("Thanks for your comment!\n");
        }
        body.append("-------------------------------------------------------\n");
        body.append("Comment Id: " + comment.getCommentId() + "\n");
        body.append("Headline: " + headline + "\n");
        body.append("Target: " + commentTarget + "\n");
        body.append("Source_Id: " + stableId + "\n");
        body.append("Comment: " + content + "\n");
        body.append("PMID: " + pmIdStr + "\n");
        body.append("Uploaded File: ");
        for(String f: files) {
          body.append(f.substring(f.indexOf('|')+1) + "; ");
        }
        body.append("\n");
        body.append("Related Genes: " + associatedStableIdsStr + "\n");
        body.append("Accession: " + accessionStr + "\n");
        body.append("Email: " + email + "\n");
        body.append("Organism: " + organism + "\n");
        body.append("DB Name: " + extDbName + "\n");
        body.append("DB Version: " + extDbVersion + "\n");
        body.append("Comment Link: " + link + "\n");
        body.append("-------------------------------------------------------\n");

        // redirect back to the referer page
        request.setAttribute("submitStatus", "success");
        request.setAttribute("subject", headline);
        request.setAttribute("body", body.toString());

        return forward;
    }

    private String handleDelimiter(String str) {
       return Pattern.compile("[\\s,;]").matcher(str).replaceAll(" ");
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

}
