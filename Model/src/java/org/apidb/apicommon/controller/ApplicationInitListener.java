package org.apidb.apicommon.controller;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.eupathdb.common.controller.EuPathSiteSetup;
import org.gusdb.wdk.controller.WdkInitializer;
import org.gusdb.wdk.model.WdkModel;

/**
 * A class that is initialized at the start of the web application. This makes
 * sure global resources are available to all the contexts that need them
 */
public class ApplicationInitListener implements ServletContextListener {

  @Override
  public void contextInitialized(ServletContextEvent sce) {
    ServletContext context = sce.getServletContext();
    WdkInitializer.initializeWdk(context);
    CommentFactoryManager.initializeCommentFactory(context);
    WdkModel wdkModel = WdkInitializer.getWdkModel(context);
    EuPathSiteSetup.initialize(wdkModel);
    ApiSiteSetup.initialize(wdkModel);
  }

  @Override
  public void contextDestroyed(ServletContextEvent sce) {
    ServletContext context = sce.getServletContext();
    CommentFactoryManager.terminateCommentFactory(context);
    WdkInitializer.terminateWdk(context);
  }
}
