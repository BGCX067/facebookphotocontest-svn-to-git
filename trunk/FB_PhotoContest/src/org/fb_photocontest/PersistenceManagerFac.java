package org.fb_photocontest;

import javax.jdo.JDOHelper;
import javax.jdo.PersistenceManagerFactory;

public final class PersistenceManagerFac{
    private static final PersistenceManagerFactory pmfInstance =
        JDOHelper.getPersistenceManagerFactory("transactions-optional");

    private PersistenceManagerFac() {}

    public static PersistenceManagerFactory getInstance() {
        return pmfInstance;
    }
}