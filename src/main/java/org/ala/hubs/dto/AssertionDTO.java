package org.ala.hubs.dto;

import java.util.ArrayList;
import java.util.List;

public class AssertionDTO {

    String name;
    int code;
    boolean isAssertionByUser;
    List<String> userIds = new ArrayList<String>();
    List<String> userDisplayNames = new ArrayList<String>();
    /**
     * This is the UUID of the assertion made by the user
     * This will be blank for assertions made by other users
     */
    String usersAssertionUuid;

    public boolean isAssertionByUser() {
        return isAssertionByUser;
    }

    public void setAssertionByUser(boolean assertionByUser) {
        isAssertionByUser = assertionByUser;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<String> getUserIds() {
        return userIds;
    }

    public void setUserIds(List<String> userIds) {
        this.userIds = userIds;
    }

    public List<String> getUserDisplayNames() {
        return userDisplayNames;
    }

    public void setUserDisplayNames(List<String> userDisplayNames) {
        this.userDisplayNames = userDisplayNames;
    }

    public String getUsersAssertionUuid() {
        return usersAssertionUuid;
    }

    public void setUsersAssertionUuid(String usersAssertionUuid) {
        this.usersAssertionUuid = usersAssertionUuid;
    }
}
