package org.apidb.apicommon.jmx.util;

import org.apache.log4j.Logger;
import org.gusdb.wdk.controller.CConstants;
import org.gusdb.wdk.model.WdkModel;
import org.gusdb.wdk.model.jspwrap.WdkModelBean;
import org.gusdb.wdk.model.WdkUserException;
import org.gusdb.wdk.model.WdkModelException;
import javax.servlet.ServletContext;


public class Util {
  protected ServletContext context;
  protected WdkModelBean wdkModelBean;
  protected WdkModel wdkModel;
  private static final Logger logger = Logger.getLogger(Util.class);

  public Util(ServletContext context) {
    this.context = context;
    wdkModelBean = (WdkModelBean) context.getAttribute(CConstants.WDK_MODEL_KEY);
    wdkModel = wdkModelBean.getModel();
  }

  public WdkModelBean getWdkModelBean() {
    return wdkModelBean;
  }
  
  public WdkModel getWdkModel() {
    return wdkModel;
  }

  public ServletContext getApplication() {
    return context;
  }
}
