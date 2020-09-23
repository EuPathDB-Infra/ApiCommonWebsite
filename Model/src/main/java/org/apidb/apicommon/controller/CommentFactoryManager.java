package org.apidb.apicommon.controller;

import org.apache.log4j.Logger;
import org.apidb.apicommon.model.comment.CommentFactory;
import org.gusdb.fgputil.logging.MDCUtil;
import org.gusdb.fgputil.runtime.InstanceManager;
import org.gusdb.fgputil.web.ApplicationContext;
import org.gusdb.wdk.controller.WdkInitializer;
import org.gusdb.wdk.model.Utilities;

/**
 * Manages initialization, access, and termination of the CommentFactory singleton
 * 
 * @author xingao
 */
public class CommentFactoryManager {

  public static final Logger LOG = Logger.getLogger(CommentFactoryManager.class);
  
  public static final String COMMENT_FACTORY_KEY = "comment-factory";

  public static CommentFactory getCommentFactory(String projectId) {
    return InstanceManager.getInstance(CommentFactory.class, projectId);
  }

  public static CommentFactory getCommentFactory(ApplicationContext context) {
    CommentFactory factory = (CommentFactory) context.get(COMMENT_FACTORY_KEY);
    if (factory == null) {
      factory = getCommentFactory(context.getInitParameter(Utilities.ARGUMENT_PROJECT_ID));
      context.put(COMMENT_FACTORY_KEY, factory);
    }
    return factory;
  }

  public static void initializeCommentFactory(ApplicationContext context) {
    // can only open comment factory if model successfully initialized
    if (WdkInitializer.getWdkModel(context) != null) {
      MDCUtil.setNonRequestThreadVars("cmnt");
      try {
        getCommentFactory(context);
      }
      catch (Exception e) {
        LOG.error("Error while initializing CommentFactory (comments DB)", e);
      }
    }
  }

  public static void terminateCommentFactory(ApplicationContext context) {
    // can only close comment factory if model successfully initialized
    if (WdkInitializer.getWdkModel(context) != null) {
      MDCUtil.setNonRequestThreadVars("cmnt");
      try {
        getCommentFactory(context).close();
      }
      catch (Exception e) {
        LOG.error("Error while terminating CommentFactory (comments DB)", e);
      }
    }
  }
}
