/**
 * 
 */
package org.apidb.apicommon.model;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;

import org.apache.log4j.Logger;
import org.gusdb.wdk.model.WdkModel;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.WdkUserException;
import org.gusdb.wdk.model.dbms.DBPlatform;
import org.gusdb.wdk.model.dbms.SqlUtils;
import org.json.JSONException;
import org.xml.sax.SAXException;

/**
 * @author xingao
 * 
 */
public class CommentFactory {

    private static CommentFactory factory;

    private Logger logger = Logger.getLogger(CommentFactory.class);
    private DBPlatform platform;
    private CommentConfig config;

    public static void initialize(String gusHome, String projectId)
            throws NoSuchAlgorithmException, WdkModelException,
            ParserConfigurationException, TransformerFactoryConfigurationError,
            TransformerException, IOException, SAXException, SQLException,
            JSONException, WdkUserException, InstantiationException,
            IllegalAccessException, ClassNotFoundException {
        WdkModel wdkModel = WdkModel.construct(projectId, gusHome);

        // parse and load the configuration
        CommentConfigParser parser = new CommentConfigParser(gusHome);
        CommentConfig config = parser.parseConfig(projectId);

        // create a platform object
        DBPlatform platform = (DBPlatform) Class.forName(
                config.getPlatformClass()).newInstance();
        platform.initialize(wdkModel, "Comment", config);

        // create a factory instance
        factory = new CommentFactory(platform, config);
    }

    public static CommentFactory getInstance() throws WdkModelException {
        if (factory == null)
            throw new WdkModelException(
                    "Please initialize the factory properly.");
        return factory;
    }

    private CommentFactory(DBPlatform platform, CommentConfig config) {
        this.platform = platform;
        this.config = config;
    }

    public CommentTarget getCommentTarget(String internalValue)
            throws WdkModelException {

        // load the comment target definition of the given internal value

        ResultSet rs = null;
        CommentTarget target = null;
        String query = null;
        try {
            query = "SELECT * FROM " + config.getCommentSchema()
                    + "comment_target WHERE comment_target_id=?";
            PreparedStatement ps = SqlUtils.getPreparedStatement(
                    platform.getDataSource(), query);
            ps.setString(1, internalValue);
            rs = ps.executeQuery();
            if (!rs.next())
                throw new WdkModelException("The comment target cannot be "
                        + "found with the given internal value: "
                        + internalValue);

            target = new CommentTarget(internalValue);
            target.setDisplayName(rs.getString("comment_target_name"));
            target.setRequireLocation((rs.getInt("require_location") != 0));
        } catch (SQLException ex) {
            throw new WdkModelException(ex);
        } finally {
            // close the connection
            try {
                SqlUtils.closeResultSet(rs);
            } catch (SQLException ex) {
                throw new WdkModelException(ex);
            }
        }
        return target;
    }

    public void addComment(Comment comment) throws WdkModelException {
        String commentSchema = config.getCommentSchema();

        PreparedStatement ps = null;
        // get a new comment id
        try {
            // DataSource dataSource = platform.getDataSource();
            int commentId = platform.getNextId(commentSchema, "comments");
            int[] targetCategoryIds = comment.getTargetCategoryIds();
            String[] pmIds = comment.getPmIds();
            String[] accessions = comment.getAccessions();
            String[] files = comment.getFiles();
            String[] associatedStableIds = comment.getAssociatedStableIds();

            ps = SqlUtils.getPreparedStatement(platform.getDataSource(),
                           "INSERT INTO " + commentSchema + "comments (comment_id, "
                            + "email, comment_date, comment_target_id, "
                            + "stable_id, conceptual, project_name, "
                            + "project_version, headline, content, "
                            + "location_string, review_status_id, organism) "
                            + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)");

            long currentMillis = System.currentTimeMillis();

            ps.setInt(1, commentId);
            ps.setString(2, comment.getEmail());
            ps.setTimestamp(3, new Timestamp(currentMillis));
            ps.setString(4, comment.getCommentTarget());
            ps.setString(5, comment.getStableId());
            ps.setBoolean(6, comment.isConceptual());
            ps.setString(7, comment.getProjectName());
            ps.setString(8, comment.getProjectVersion());
            ps.setString(9, comment.getHeadline());
            platform.updateClobData(ps, 10, comment.getContent(), false);
            ps.setString(11, comment.getLocationString());
            String reviewStatus = (comment.getReviewStatus() != null && comment.getReviewStatus().length() > 0)
                    ? comment.getReviewStatus()
                    : Comment.COMMENT_REVIEW_STATUS_UNKNOWN;
            ps.setString(12, reviewStatus);
            ps.setString(13, comment.getOrganism());

            int result = ps.executeUpdate();
            logger.debug("Inserted comment row: " + result);

            // update the fields of comment
            comment.setCommentDate(new java.util.Date(currentMillis));
            comment.setCommentId(commentId);

            // then add the location information
            saveLocations(commentId, comment);

            // then add the eternal database information
            saveExternalDbs(commentId, comment);

            if((targetCategoryIds != null) && (targetCategoryIds.length > 0)){
              saveCommentTargetCategory(commentId, targetCategoryIds);
            }                                               

            if((pmIds != null) && (pmIds.length > 0)){
              savePmIds(commentId, pmIds);
            }                                               

            if((accessions != null) && (accessions.length > 0)){
              saveAccessions(commentId, accessions);
            }                                               

            if((files != null) && (files.length > 0)){
              saveFiles(commentId, files);
            }                                               

            if((associatedStableIds != null) && (associatedStableIds.length > 0)){
              saveAssociatedStableIds(commentId, associatedStableIds);
            }                                               

            if(comment.getCommentTarget().equalsIgnoreCase("phenotype")) {
              savePhenotype(commentId, 
                            comment.getBackground(), 
                            comment.getMutantStatus(),
                            comment.getMutationType(),
                            comment.getMutationMethod(),
                            comment.getContent()
                            );
            }

            // get a new comment in order to fetch the user info
            Comment newComment = getComment(commentId);

            comment.setUserName(newComment.getUserName());
            comment.setOrganization(newComment.getOrganization());
        } catch (SQLException ex) {
            ex.printStackTrace();
            throw new WdkModelException(ex);
        } finally {
            try {
                SqlUtils.closeStatement(ps);
            } catch (SQLException ex) {
                throw new WdkModelException(ex);
            }
        }

        // print connection status
        printStatus();
    }

    private void saveLocations(int commentId, Comment comment)
            throws SQLException, org.gusdb.wdk.model.WdkModelException {
        String commentSchema = config.getCommentSchema();

        // construct sql
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO " + commentSchema + "locations (comment_id, ");
        sql.append("location_id, location_start, location_end, is_reverse, ");
        sql.append("coordinate_type) VALUES (?, ?, ?, ?, ?, ?)");
        PreparedStatement statement = null;
        try {
            statement = SqlUtils.getPreparedStatement(platform.getDataSource(),
                    sql.toString());

            Location[] locations = comment.getLocations();
            for (Location location : locations) {
                int locationId = platform.getNextId(commentSchema, "locations");
                statement.setInt(1, commentId);
                statement.setInt(2, locationId);
                statement.setLong(3, location.getLocationStart());
                statement.setLong(4, location.getLocationEnd());
                statement.setBoolean(5, location.isReversed());
                statement.setString(6, location.getCoordinateType());
                statement.execute();
            }
        } finally {
            SqlUtils.closeStatement(statement);
        }
    }

    private void savePhenotype(int commentId, 
                               String background,
                               int mutantStatus,
                               int mutationType,
                               int mutationMethod,
                               String phenotypeDescription)
            throws SQLException, WdkModelException {

        String commentSchema = config.getCommentSchema();

        // construct sql
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO " + commentSchema + "Phenotype ");
        sql.append("(phenotype_id, comment_id, ");
        sql.append("background, mutant_status_id, mutant_type_id, ");
        sql.append("mutant_method_id, phenotype_description ");
        sql.append(") VALUES (?, ?, ?, ?, ?, ?, ?)");
        PreparedStatement statement = null;
        try {
            statement = SqlUtils.getPreparedStatement(platform.getDataSource(),
                        sql.toString());
      
             statement.setInt(1, platform.getNextId(commentSchema, "phenotype"));
             statement.setInt(2, commentId);
             statement.setString(3, background);
             statement.setInt(4, mutantStatus);
             statement.setInt(5, mutationType);
             statement.setInt(6, mutationMethod);
             statement.setString(7, phenotypeDescription);
             statement.execute();
        } finally {
            SqlUtils.closeStatement(statement);
        }
    }


    private void saveCommentTargetCategory(int commentId, int[] targetCategoryIds)
            throws SQLException, WdkModelException {
        String commentSchema = config.getCommentSchema();
      
        // construct sql
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO " + commentSchema + "CommentTargetCategory ");
        sql.append("(comment_target_category_id, comment_id, ");
        sql.append("target_category_id ");
        sql.append(") VALUES (?, ?, ?)");
        PreparedStatement statement = null;
        try {
            statement = SqlUtils.getPreparedStatement(platform.getDataSource(),
                        sql.toString());
      
            for (int targetCategoryId : targetCategoryIds) {
                statement.setInt(1, platform.getNextId(commentSchema, "commentTargetCategory"));
                statement.setInt(2, commentId);
                statement.setInt(3, targetCategoryId);
                statement.execute();
            }
        } finally {
            SqlUtils.closeStatement(statement);
        }
    }

    private void savePmIds(int commentId, String[] pmIds)
            throws SQLException, WdkModelException {
        String commentSchema = config.getCommentSchema();
        int commentPmId = platform.getNextId(commentSchema, "commentReference");
      
        // construct sql
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO " + commentSchema + "CommentReference ");
        sql.append("(comment_reference_id, source_id, ");
        sql.append("database_name, comment_id ");
        sql.append(") VALUES (?, ?, ?, ?)");
        PreparedStatement statement = null;
        try {
            statement = SqlUtils.getPreparedStatement(platform.getDataSource(),
                        sql.toString());
      
            for (String pmId : pmIds) {
                if((pmId != null ) && (pmId.trim().length() != 0)) {
                    statement.setInt(1, platform.getNextId(commentSchema, "commentReference"));
                    statement.setString(2, pmId);
                    statement.setString(3, "pubmed");
                    statement.setInt(4, commentId);
                    statement.execute();
                }
            }
        } finally {
            SqlUtils.closeStatement(statement);
        }
    }

    private void saveAccessions(int commentId, String[] accessions)
            throws SQLException, WdkModelException {
        String commentSchema = config.getCommentSchema();
        int commentPmId = platform.getNextId(commentSchema, "commentReference");
      
        // construct sql
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO " + commentSchema + "CommentReference ");
        sql.append("(comment_reference_id, source_id, ");
        sql.append("database_name, comment_id ");
        sql.append(") VALUES (?, ?, ?, ?)");
        PreparedStatement statement = null;
        try {
            statement = SqlUtils.getPreparedStatement(platform.getDataSource(),
                        sql.toString());
      
            for (String accession : accessions) {
                if((accession != null ) && (accession.trim().length() != 0)) {
                    statement.setInt(1, platform.getNextId(commentSchema, "commentReference"));
                    statement.setString(2, accession);
                    statement.setString(3, "genbank");
                    statement.setInt(4, commentId);
                    statement.execute();
                }
            }
        } finally {
            SqlUtils.closeStatement(statement);
        }
    }

    private void saveFiles(int commentId, String[] files)
            throws SQLException, WdkModelException {
        String commentSchema = config.getCommentSchema();

        // construct sql
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO " + commentSchema + "CommentFile ");
        sql.append("(file_id, name, notes, ");
        sql.append(" comment_id ");
        sql.append(") VALUES (?, ?, ?, ?)");
        PreparedStatement statement = null;
        try {
            statement = SqlUtils.getPreparedStatement(platform.getDataSource(),
                        sql.toString());
      
            for (String file : files) {
                if(file == null ) continue; 
                String[] str = file.split("\\|");
                statement.setInt(1, Integer.parseInt(str[0]));
                statement.setString(2, str[1]);
                statement.setString(3, str[2]);
                statement.setInt(4, commentId);
                statement.execute();
            }
        } finally {
            SqlUtils.closeStatement(statement);
        }
    }

    private void saveAssociatedStableIds(int commentId, String[] associatedStableIds)
            throws SQLException, WdkModelException {
        String commentSchema = config.getCommentSchema();
        int stableId = platform.getNextId(commentSchema, "commentStableId");
      
        // construct sql
        StringBuffer sql = new StringBuffer();
        sql.append("INSERT INTO " + commentSchema + "CommentStableId ");
        sql.append("(comment_stable_id, stable_id, ");
        sql.append(" comment_id ");
        sql.append(") VALUES (?, ?, ?)");
        PreparedStatement statement = null;
        try {
            statement = SqlUtils.getPreparedStatement(platform.getDataSource(),
                        sql.toString());
      
            for (String associatedStableId : associatedStableIds) {
                if((associatedStableId != null ) && (associatedStableId.trim().length() != 0)) {
                    statement.setInt(1, platform.getNextId(commentSchema, "commentStableId"));
                    statement.setString(2, associatedStableId);
                    statement.setInt(3, commentId);
                    statement.execute();
                }
            }
        } finally {
            SqlUtils.closeStatement(statement);
        }
     }


    /**
     * For the first release, this method hard-code the external database name
     * and version, instead of looking up directly in GUS. This avoids the
     * backward dblink requirement; The site should provide such information to
     * the comment factory in future releases.
     * 
     * UPDATE: Assume that the Comment parameter already has the external
     * database info filled in. Use the first extdb/versions (Is there a case at
     * all where we need more than one ext db???)
     * 
     * @param commentId
     * @param comment
     * @throws SQLException
     * @throws WdkModelException
     */
    private void saveExternalDbs(int commentId, Comment comment)
            throws SQLException, WdkModelException {
        String commentSchema = config.getCommentSchema();
        // String dblink = config.getProjectDbLink();
        // String stableId = comment.getStableId();
        DataSource dataSource = platform.getDataSource();

        // construct sqls
        StringBuffer sqlQueryDb = new StringBuffer();
        sqlQueryDb.append("SELECT external_database_id ");
        sqlQueryDb.append("FROM " + commentSchema + "external_databases ");
        sqlQueryDb.append("WHERE external_database_name = ? ");
        sqlQueryDb.append("AND external_database_version = ?");

        StringBuffer sqlInsertDb = new StringBuffer();
        sqlInsertDb.append("INSERT INTO " + commentSchema
                + "external_databases ");
        sqlInsertDb.append("(external_database_id, external_database_name, ");
        sqlInsertDb.append("external_database_version) VALUES (?, ?, ?)");

        StringBuffer sqlInsertLink = new StringBuffer();
        sqlInsertLink.append("INSERT INTO " + commentSchema
                + "comment_external_database ");
        sqlInsertLink.append("(external_database_id, comment_id) ");
        sqlInsertLink.append("VALUES (?, ?)");

        PreparedStatement psQUeryDb = null, psInsertDb = null, psInsertLink = null;
        try {
            // construct prepared statements
            psQUeryDb = SqlUtils.getPreparedStatement(dataSource,
                    sqlQueryDb.toString());

            psInsertDb = SqlUtils.getPreparedStatement(dataSource,
                    sqlInsertDb.toString());

            psInsertLink = SqlUtils.getPreparedStatement(dataSource,
                    sqlInsertLink.toString());

            // add every external database record into the database
            for (ExternalDatabase externalDb : comment.getExternalDbs()) {
                psQUeryDb.setString(1, externalDb.getExternalDbName());
                psQUeryDb.setString(2, externalDb.getExternalDbVersion());
                ResultSet rsQueryDb = null;
                int externalDbId;
                try {
                    rsQueryDb = psQUeryDb.executeQuery();
                    if (!rsQueryDb.next()) {
                        // external database entry doesn't exist
                        externalDbId = platform.getNextId(commentSchema,
                                "external_databases");
                        psInsertDb.setInt(1, externalDbId);
                        psInsertDb.setString(2, externalDb.getExternalDbName());
                        psInsertDb.setString(3,
                                externalDb.getExternalDbVersion());
                        psInsertDb.execute();
                    } else { // has entry, get the external_database_id
                        externalDbId = rsQueryDb.getInt("external_database_id");
                    }
                } finally {
                    // the ResultSet is closed manually, instead of using
                    // SqlUtilssince we need to keep the underline statement
                    // open during the for loop
                    rsQueryDb.close();
                }

                // add the reference link
                psInsertLink.setInt(1, externalDbId);
                psInsertLink.setInt(2, commentId);
                psInsertLink.execute();
            }
        } finally {
            // close statements and result set
            SqlUtils.closeStatement(psQUeryDb);
            SqlUtils.closeStatement(psInsertDb);
            SqlUtils.closeStatement(psInsertLink);
        }
    }

    public Comment getComment(int commentId) throws WdkModelException {
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT c.email, c.comment_date, c.comment_target_id, ");
        sql.append("c.conceptual, c.headline, c.project_name, ");
        sql.append("c.project_version, c.review_status_id, c.stable_id, ");
        sql.append("substr(c.organism, 1, instr(c.organism || '  ', ' ', 1, 2)-1) as organism, ");
        sql.append("u.first_name || ' ' || u.last_name || ', ' || u.title  as user_name, ");
        sql.append("u.organization, c.content FROM ");
        sql.append(config.getCommentSchema() + "comments c, ");
        sql.append(config.getUserLoginSchema() + "users"
                + config.getUserLoginDbLink() + " u ");
        sql.append("WHERE lower(c.email) = lower(u.email) ");
        sql.append("AND c.comment_id = ? ");

        ResultSet rs = null;
        try {
            PreparedStatement ps = SqlUtils.getPreparedStatement(
                    platform.getDataSource(), sql.toString());
            ps.setInt(1, commentId);
            rs = ps.executeQuery();

            if (!rs.next())
                throw new WdkModelException("Comment of the given id '"
                        + commentId + "' cannot be found.");

            // construct a comment object
            Comment comment = new Comment(rs.getString("email"));
            comment.setCommentId(commentId);
            comment.setCommentDate(rs.getTimestamp("comment_date"));
            comment.setCommentTarget(rs.getString("comment_target_id"));
            comment.setConceptual(rs.getBoolean("conceptual"));
            comment.setHeadline(rs.getString("headline"));
            comment.setProjectName(rs.getString("project_name"));
            comment.setProjectVersion(rs.getString("project_version"));
            comment.setReviewStatus(rs.getString("review_status_id"));
            comment.setStableId(rs.getString("stable_id"));
            comment.setOrganism(rs.getString("organism"));
            comment.setUserName(rs.getString("user_name"));
            comment.setOrganization(rs.getString("organization"));

            // get clob content
            comment.setContent(platform.getClobData(rs, "content"));

            // load locations
            loadLocations(commentId, comment);

            // load external databases
            loadExternalDbs(commentId, comment);

            // load pubmed ids
            loadReference(commentId, comment, "pubmed");

            // load genbank ids
            loadReference(commentId, comment, "genbank");

            // load files
            loadFiles(commentId, comment);

            // load associated stable ids
            loadStableIds(commentId, comment);

            // load target category names
            loadTargetCategoryNames(commentId, comment);

            return comment;
        } catch (SQLException ex) {
            ex.printStackTrace();
            throw new WdkModelException(ex);
        } finally {
            try {
                SqlUtils.closeResultSet(rs);
            } catch (SQLException ex) {
                throw new WdkModelException(ex);
            }

            // print connection status
            printStatus();
        }
    }

    private void loadReference(int commentId, Comment comment, String databaseName)
            throws SQLException {
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT source_id ");
        sql.append(" FROM ");
        sql.append(config.getCommentSchema() + "commentReference ");
        sql.append("WHERE comment_id = ? and database_name = ?");

        ResultSet rs = null;
        try {
            PreparedStatement ps = SqlUtils.getPreparedStatement(
                    platform.getDataSource(), sql.toString());
            ps.setInt(1, commentId);
            ps.setString(2, databaseName);
            rs = ps.executeQuery();

            ArrayList<String> ids = new ArrayList<String>();
            while (rs.next()) {
                String sourceId = rs.getString("source_id");
                ids.add(sourceId);
            }
            if(ids.size() > 0) {
              comment.addReference(ids.toArray(new String[ids.size()]), databaseName);
            }
        } finally {
            SqlUtils.closeResultSet(rs);
        }
    }

    private void loadTargetCategoryNames(int commentId, Comment comment)
            throws SQLException {
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT b.category ");
        sql.append(" FROM ");
        sql.append(config.getCommentSchema() + "commentTargetCategory a, ");
        sql.append(config.getCommentSchema() + "targetCategory b ");
        sql.append("WHERE a.target_category_id = b.target_category_id AND a.comment_id = ?");

        ResultSet rs = null;
        try {
            PreparedStatement ps = SqlUtils.getPreparedStatement(
                    platform.getDataSource(), sql.toString());
            ps.setInt(1, commentId);
            rs = ps.executeQuery();

            ArrayList<String> ids = new ArrayList<String>();
            while (rs.next()) {
                String category = rs.getString("category");
                ids.add(category);
            }
            if(ids.size() > 0) {
              comment.addTargetCategoryNames(ids.toArray(new String[ids.size()]));
            }
        } finally {
            SqlUtils.closeResultSet(rs);
        }
    }

    private void loadFiles(int commentId, Comment comment)
            throws SQLException {
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT file_id, name, notes ");
        sql.append(" FROM ");
        sql.append(config.getCommentSchema() + "commentFile ");
        sql.append("WHERE comment_id = ?");

        ResultSet rs = null;
        try {
            PreparedStatement ps = SqlUtils.getPreparedStatement(
                    platform.getDataSource(), sql.toString());
            ps.setInt(1, commentId);
            rs = ps.executeQuery();

            ArrayList<String> ids = new ArrayList<String>();
            while (rs.next()) {
                int file_id = rs.getInt("file_id");
                String name = rs.getString("name");
                String notes = rs.getString("notes");
                ids.add(file_id + "|" + name + "|" + notes);
            }
            if(ids.size() > 0) {
              comment.addFiles(ids.toArray(new String[ids.size()]));
            }
        } finally {
            SqlUtils.closeResultSet(rs);
        }
    }

    private void loadStableIds(int commentId, Comment comment)
            throws SQLException {
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT stable_id ");
        sql.append(" FROM ");
        sql.append(config.getCommentSchema() + "CommentStableId ");
        sql.append("WHERE comment_id = ?");

        ResultSet rs = null;
        try {
            PreparedStatement ps = SqlUtils.getPreparedStatement(
                    platform.getDataSource(), sql.toString());
            ps.setInt(1, commentId);
            rs = ps.executeQuery();

            ArrayList<String> ids = new ArrayList<String>();
            while (rs.next()) {
                String stable_id = rs.getString("stable_id");
                ids.add(stable_id);
            }
            if(ids.size() > 0) {
              comment.addAssociatedStableIds(ids.toArray(new String[ids.size()]));
            }
        } finally {
            SqlUtils.closeResultSet(rs);
        }
    }

    private void loadLocations(int commentId, Comment comment)
            throws SQLException {
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT location_start, location_end, is_reverse, ");
        sql.append("coordinate_type FROM ");
        sql.append(config.getCommentSchema() + "locations ");
        sql.append("WHERE comment_id = ?");

        ResultSet rs = null;
        try {
            PreparedStatement ps = SqlUtils.getPreparedStatement(
                    platform.getDataSource(), sql.toString());
            ps.setInt(1, commentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                long start = rs.getLong("location_start");
                long end = rs.getLong("location_end");
                boolean reversed = rs.getBoolean("is_reverse");
                String coordinateType = rs.getString("coordinate_type");
                comment.addLocation(reversed, start, end, coordinateType);
            }
        } finally {
            SqlUtils.closeResultSet(rs);
        }
    }

    private void loadExternalDbs(int commentId, Comment comment)
            throws SQLException {
        String commentSchema = config.getCommentSchema();

        StringBuffer sql = new StringBuffer();
        sql.append("SELECT ed.external_database_name, ed.external_database_version ");
        sql.append("FROM " + commentSchema + "external_databases ed, ");
        sql.append(commentSchema + "comment_external_database ced ");
        sql.append("WHERE ced.comment_id = ?");
        sql.append(" AND ced.external_database_id = ed.external_database_id");

        ResultSet rs = null;
        try {
            PreparedStatement ps = SqlUtils.getPreparedStatement(
                    platform.getDataSource(), sql.toString());
            ps.setInt(1, commentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                String externalDbName = rs.getString("external_database_name");
                String externalDbVersion = rs.getString("external_database_version");
                comment.addExternalDatabase(externalDbName, externalDbVersion);
            }
        } finally {
            SqlUtils.closeResultSet(rs);
        }
    }

    public Comment[] queryComments(String email, String projectName,
            String stableId, String conceptual, String reviewStatus,
            String keyword) throws WdkModelException {
        DataSource dataSource = platform.getDataSource();

        StringBuffer where = new StringBuffer();
        if (email != null) {
            email = email.replace('*', '%');
            email = email.replaceAll("'", "");
            where.append(" lower(c.email) like lower('" + email + "')");
        }
        if (projectName != null) {
            projectName = projectName.replace('*', '%');
            projectName = projectName.replaceAll("'", "");
            if (where.length() > 0) where.append(" AND");
            where.append(" c.project_name like '" + projectName + "'");
        }
        if (stableId != null) {
            stableId = stableId.replace('*', '%');
            stableId = stableId.replaceAll("'", "");
            if (where.length() > 0) where.append(" AND ");
            where.append(" (c.stable_id like '" + stableId + "'");
            where.append(" OR d.stable_id like '" + stableId + "') "); 
        }
        if (conceptual != null) {
            boolean concpt = Boolean.parseBoolean(conceptual);
            if (where.length() > 0) where.append(" AND ");
            where.append(" c.conceptual like " + concpt);
        }
        if (reviewStatus != null) {
            reviewStatus = stableId.replace('*', '%');
            reviewStatus = stableId.replaceAll("'", "");
            if (where.length() > 0) where.append(" AND ");
            where.append(" c.review_status like '" + reviewStatus + "'");
        }
        if (keyword != null) {
            keyword = stableId.replace('*', '%');
            keyword = stableId.replaceAll("'", "");
            if (where.length() > 0) where.append(" AND ");
            where.append(" (c.headline like '" + keyword);
            where.append("' OR c.content like '" + keyword + "')");
        }

        StringBuffer sql = new StringBuffer();
        sql.append("SELECT distinct * FROM ( ");
        sql.append("SELECT c.comment_id FROM ");
        sql.append(config.getCommentSchema() + "comments c, ");
        sql.append(config.getCommentSchema() + "commentStableId d, "); 
        sql.append(config.getUserLoginSchema() + "users"
                + config.getUserLoginDbLink() + " u ");
        sql.append("WHERE lower(c.email) = lower(u.email) ");
        sql.append("AND c.comment_id = d.comment_id(+) "); 
        if (where.length() > 0) sql.append(" AND " + where.toString());
        sql.append(" ORDER BY c.comment_date DESC, c.organism ASC, c.stable_id ASC)");

        List<Comment> comments = new ArrayList<Comment>();
        ResultSet rs = null;
        try {
            rs = SqlUtils.executeQuery(dataSource, sql.toString());
            while (rs.next()) {
                int commentId = rs.getInt("comment_id");
                Comment comment = getComment(commentId);
                comments.add(comment);
            }
        } catch (SQLException ex) {
            throw new WdkModelException(ex);
        } finally {
            try {
                SqlUtils.closeResultSet(rs);
            } catch (SQLException ex) {
                throw new WdkModelException(ex);
            }

            // print connection status
            printStatus();
        }
        Comment[] array = new Comment[comments.size()];
        comments.toArray(array);

        return array;
    }

    public void deleteComment(int commentId) throws WdkModelException {
        String commentSchema = config.getCommentSchema();
        DataSource dataSource = platform.getDataSource();

        ResultSet rs = null;
        try {
            rs = SqlUtils.executeQuery(dataSource, "SELECT project_name FROM "
                    + commentSchema + "comments WHERE comment_id = "
                    + commentId);
            if (!rs.next()) {
                logger.warn("DeleteComment: Did not find a comment for id "
                        + commentId);
                return;
            }

            // delete the location information
            String sql = "DELETE FROM " + commentSchema + "locations "
                    + "WHERE comment_id = " + commentId;
            SqlUtils.executeUpdate(dataSource, sql);

            // delete associated external database info
            sql = "DELETE FROM " + commentSchema + "comment_external_database "
                    + "WHERE comment_id = " + commentId;
            SqlUtils.executeUpdate(dataSource, sql);

            // delete comment information
            sql = "DELETE FROM " + commentSchema + "comments "
                    + " WHERE comment_id = " + commentId;
            SqlUtils.executeUpdate(dataSource, sql);
        } catch (SQLException ex) {
            throw new WdkModelException(ex);
        } finally {
            try {
                SqlUtils.closeResultSet(rs);
            } catch (SQLException ex) {
                throw new WdkModelException(ex);
            }

            // print connection status
            printStatus();
        }
    }

    public CommentConfig getCommentConfig() {
        return config;
    }

    private void printStatus() {
        int active = platform.getActiveCount();
        int idle = platform.getIdleCount();
        logger.info("Comment connections: active=" + active + ", idle=" + idle);
    }
}
