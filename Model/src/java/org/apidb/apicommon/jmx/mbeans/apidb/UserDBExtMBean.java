package org.apidb.apicommon.jmx.mbeans.apidb;

import org.apidb.apicommon.jmx.mbeans.wdk.UserDBMBean;
import java.util.Map;

public interface UserDBExtMBean extends UserDBMBean {
    public String getaliases_from_ldap();
}


