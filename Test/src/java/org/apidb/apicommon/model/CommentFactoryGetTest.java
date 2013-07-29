/**
 * 
 */
package org.apidb.apicommon.model;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.gusdb.wdk.model.Utilities;
import org.gusdb.wdk.model.WdkModelException;
import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 * @author xingao
 * 
 */
public class CommentFactoryGetTest {

    private static final String SAMPLE_EMAIL = "WDK_GUEST_1";
    private static final String SAMPLE_STABLE_ID = "SAMPLE_0344";
    private static final String SAMPLE_PROJECT_VERSION = "1.1";
    private static final String SAMPLE_COMMENT_TARGET = "gene";
    private static final String SAMPLE_KEYWORD = "test";
    private static final String SAMPLE_EXTERNAL_DATABASE = "PDB";
    private static final String SAMPLE_EXTERNAL_DATABASE_VERSION = "2.0";
    private static final int SAMPLE_LOCATION_START = 1;
    private static final int SAMPLE_LOCATION_END = 500;
    private static final String SAMPLE_LOCATION_COORDINATE = "genome";
    private static final boolean SAMPLE_LOCATION_REVERSED = true;

    private static String projectId;
    private static CommentFactory factory;

    private int commentId;

    @BeforeClass
    public static void loadFactory() throws WdkModelException {
        // get the projectId
        String gusHome = System.getProperty(Utilities.SYSTEM_PROPERTY_GUS_HOME);
        projectId = System.getProperty(Utilities.ARGUMENT_PROJECT_ID);

        if (gusHome == null || projectId == null)
            throw new WdkModelException("The required system property "
                    + Utilities.SYSTEM_PROPERTY_GUS_HOME + " or "
                    + Utilities.ARGUMENT_PROJECT_ID + " is missing.");

        // initialize comment factory
        factory = CommentFactory.getInstance(gusHome, projectId);
    }

    @Before
    public void addComment() throws WdkModelException {
        Comment comment = new Comment(SAMPLE_EMAIL);
        comment.setStableId(SAMPLE_STABLE_ID);
        comment.setCommentTarget(SAMPLE_COMMENT_TARGET);
        comment.setProjectName(projectId);
        comment.setProjectVersion(SAMPLE_PROJECT_VERSION);
        comment.setHeadline("A " + SAMPLE_KEYWORD + " comment");
        comment.setContent("The content of a sample content");
        comment.addExternalDatabase(SAMPLE_EXTERNAL_DATABASE,
                SAMPLE_EXTERNAL_DATABASE_VERSION);
        comment.setLocations(SAMPLE_LOCATION_REVERSED, SAMPLE_LOCATION_START
                + "-" + SAMPLE_LOCATION_END, SAMPLE_LOCATION_COORDINATE);

        factory.addComment(comment);

        // get the comment id
        commentId = comment.getCommentId();
    }

    @After
    public void removeComment() throws WdkModelException {
        factory.deleteComment(SAMPLE_EMAIL, Integer.toString(commentId));
    }

    @Test
    public void testGetCommentById() throws WdkModelException {
        Comment comment = factory.getComment(commentId);
        assertEquals("comment id", commentId, comment.getCommentId());
        assertEquals("project id", projectId, comment.getProjectName());
        assertEquals("project version", SAMPLE_PROJECT_VERSION,
                comment.getProjectVersion());
        assertEquals("stable id", SAMPLE_STABLE_ID, comment.getStableId());
        assertEquals("comment target", SAMPLE_COMMENT_TARGET,
                comment.getCommentTarget());

        // check the external database info
        ExternalDatabase[] exdbs = comment.getExternalDbs();
        assertEquals("external database", SAMPLE_EXTERNAL_DATABASE,
                exdbs[0].getExternalDbName());
        assertEquals("external database version",
                SAMPLE_EXTERNAL_DATABASE_VERSION,
                exdbs[0].getExternalDbVersion());

        // check the location information
        Location[] locations = comment.getLocations();
        assertEquals("location count", 1, locations.length);
        assertEquals("location start", SAMPLE_LOCATION_START,
                locations[0].getLocationStart());
        assertEquals("location end", SAMPLE_LOCATION_END,
                locations[0].getLocationEnd());
        assertEquals("location coordinate", SAMPLE_LOCATION_COORDINATE,
                locations[0].getCoordinateType());
        assertEquals("location reversed?", SAMPLE_LOCATION_REVERSED,
                locations[0].isReversed());
    }

    @Test
    public void testQueryCommentByStableId() throws WdkModelException {
        Comment[] array = factory.queryComments(null, null, SAMPLE_STABLE_ID,
                null, null, null, null);
        // TEST
        assertEquals("comment count", 1, array.length);
        assertEquals("comment id", commentId, array[0].getCommentId());

        // try to get nothing
        array = factory.queryComments(null, null, "NON_EXIST_STABLE_ID", null,
                null, null, null);
        assertEquals("comment count", 0, array.length);
    }

    @Test
    public void testQUeryCOmmentByProjectId() throws WdkModelException {
        Comment[] array = factory.queryComments(null, projectId, null, null,
                null, null, null);
        // TEST
        assertTrue("comment count", array.length >= 1);
        for (Comment comment : array) {
            assertEquals("project name", projectId, comment.getProjectName());
        }
    }
}
