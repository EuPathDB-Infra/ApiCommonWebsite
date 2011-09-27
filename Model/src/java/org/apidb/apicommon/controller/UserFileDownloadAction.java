package org.apidb.apicommon.controller;

import java.io.File;
import java.io.InputStream;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import org.apidb.apicommon.controller.DownloadAction;
import org.apidb.apicommon.controller.MimeTypes;
import org.apidb.apicommon.model.CommentConfig;
import org.apidb.apicommon.model.CommentFactory;
import org.gusdb.wdk.model.Utilities;

public class UserFileDownloadAction extends DownloadAction {
    
    File file;
    String gusHome;
    String projectId;
 

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception   {

        ServletContext application = getServlet().getServletContext();
        gusHome = application.getRealPath(application.getInitParameter(Utilities.SYSTEM_PROPERTY_GUS_HOME));
        projectId = application.getInitParameter(Utilities.ARGUMENT_PROJECT_ID);
 
        String fname = (String) request.getParameter("fname");

        file = getFile(fname);

        if (!file.exists()) {
            return mapping.findForward("fileNotFound");
        } else if (file.isDirectory()) {
            ActionForward forwardBase = mapping.findForward("isDir");
            String dirPath = "../" + forwardBase.getPath() + "/" + projectId + "/" + file.getName();
            System.out.println("dirPath " + dirPath);
            return new ActionForward(dirPath, true);
        } else {
            StreamInfo info = getStreamInfo(mapping, form, request, response);
            sendStreamResponse(response, info);
        }
    
        return null;        
    }

    protected void sendStreamResponse(HttpServletResponse response, 
              StreamInfo info) throws Exception {
        
        String   contentType = info.getContentType();
        InputStream   stream = info.getInputStream();

        try {
            response.setContentType(contentType);
            copy(stream, response.getOutputStream());
        } finally {
            if (stream != null) {
                stream.close();
            }
        }

    }

    protected File getFile(String fname) throws Exception {
        ServletContext context = servlet.getServletContext();
        CommentFactory factory = CommentActionUtility.getCommentFactory(context);
        CommentConfig commentConfig = factory.getCommentConfig();
        
        String uploadPath = commentConfig.getUserFileUploadDir();
        
        String filePath = uploadPath + "/" + projectId + "/" + fname;
        
        return new File(filePath);
        
    }
    
    protected StreamInfo getStreamInfo(
       ActionMapping mapping, 
       ActionForm form,
       HttpServletRequest request, 
       HttpServletResponse response) throws Exception {

       String ext = getFileNameExtension(file.getName());
       String contentType = MimeTypes.lookupMimeType(ext);
       
       if (contentType == null) {
          contentType = "application/octet-stream";
          /** Note: content-disposition is broken in Internet Explorer 5.5 
              Service Pack 1 (SP1). See
              http://support.microsoft.com/kb/q279667/
          **/
          response.setHeader("Content-disposition", 
                             "attachment; filename=" + file.getName());
        }

        return new FileStreamInfo(contentType, file);
    }

    protected String getFileNameExtension(String fname) throws Exception {
        int sep = fname.lastIndexOf(".");
        return fname.substring(sep + 1);
    }
  
}
