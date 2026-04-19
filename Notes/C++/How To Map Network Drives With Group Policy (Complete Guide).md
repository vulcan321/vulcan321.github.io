# How To Map Network Drives With Group Policy (Complete Guide)

Last Updated: December 11, 2022 by [Robert Allen](https://activedirectorypro.com/author/mug/ "View all posts by Robert Allen")

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-Featured.jpg)

In this guide, I’ll show you step by step instructions on how to map network drives with Group Policy.

If you’re still using login scripts then it’s time to switch to Group Policy.

Mapping drives with group policy is very easy and requires no scripting experience.

**Bonus:** It can actually speed up the user logon process.

I’ll show you two examples, the first one is mapping a drive for a department, the second will map a drive for individual users.

In addition, I will use item level targeting to map drives based on specific conditions like group membership, OU, operating system, etc.

## Logon Scripts VS Group Policy

The ability to map a network drive with Group Policy was introduced in Server 2008.

Logon scripts are a thing of the past.

Logon scripts can actually slow computers down. Yes, group policy is faster.

Unless you have some crazy complex script that does something that Group Policy cannot do then there is no reason not to use it.

Mapping Drives with Group Policy has the following advantages:

-   It’s much easier than logon scripts. Checkboxes and drop down lists, no need to understand scripting
-   It’s scalable. GPO mapped drives can handle very large Active Directory environments.
-   It’s very flexible. With item level targeting you can target groups, users, OUs, operating systems, and so on.
-   It’s easy

Now let’s move on to some examples of mapping drives with group policy.

## Example 1: Map a Department Network Drive Using Group Policy

In this example, I’m going to map a network drive for the HR department. I’ll use item level targeting so it only maps this drive for users in the HR organizational unit.

You could also use a Security Group to target a specific group of users. This will map to a network share that only the HR department has access to.

### Step 1: Create & Link a new GPO

1\. Open the Group Policy Management Console

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-1.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-1.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-1.jpg)

2\. In the Group Policy Management Console, Right Click and Select “Create a GPO in this domain, and Link it here”

**TIP:** This will be a user based GPO so make sure you link the GPO to a location that will target the users.  I have all of my users separated into an OU called ADPRO Users, I’ll create and link the GPO there.

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-2.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-2.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-2.jpg)

3\. Name the new GPO

You can name the new GPO whatever you like, I’ve named mine “Users – Mapped Drives

I can later add additional drive mappings to this GPO.

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-3.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-3.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-3.jpg)

The new GPO is now created and linked, now it’s time to configure the settings.

### Step 2: Configure GPO Settings

1\. On the GPO right click and select edit

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-4.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-4.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-4.jpg)

2\. Navigate to User Configuration -> Preferences -> Windows Settings -> Drive Mappings

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-5.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-5.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-5.jpg)

3\. Right Click Drive Mappings, Select New – > Mapped Drive

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-6.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-6.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-6.jpg)

4\. Configure Drive Mapping Properties

General Tab Settings

-   In location put the path to the share/folder you want to map a drive to.
-   Select a drive letter
-   Choose Update for action
-   Label as: This is optional but may be beneficial for users.

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-7.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-7.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Drives-7.jpg)

Common Tab Settings

Select “Run in logged on users’s security context

Select Item-level Targeting

Click the Targeting Button

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-item-level-targeting-2.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-item-level-targeting-2.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-item-level-targeting-2.jpg)

Select New Item

Select Organization Unit then select the OU you want to target

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-item-level-targeting.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-item-level-targeting.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-item-level-targeting.jpg)

Click OK, Click OK again to close the new drive properties

This completes the GPO settings

## Step 3: Reboot Computers to Process GPO

For the GPO to run I will need to reboot the users PC or run gpupdate /force. The next time a user from the HR department logs in they should see a mapped drive.

I’ve rebooted the computer, now I’ll log in with an account that is in the HR organizational unit.

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-MAP-Drive-Test-1.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-MAP-Drive-Test-1.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-MAP-Drive-Test-1.jpg)

Once logged I will go to file explorer and check for the mapped drive.

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-MAP-Drive-Test-2.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-MAP-Drive-Test-2.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-MAP-Drive-Test-2.jpg)

It works.

Now, any user I put in the HR folder will get this mapped drive. If you don’t want to use an OU you can also target a group of users by using a Security group.

## Example 2: Using Group Policy to Map a Drive for Individual Users

This example will map a drive for individual users. This will give the users their own personal folder to save files.

You can create a new GPO or add to your existing one, I have all my drive mappings in one GPO.

This example requires a folder to be setup on a network share that matches the user’s logon name. You will want to modify the NTFS permissions so the individual user is the only one that has permissions to it.

I’ll be using Mark Foster as an example, the logon name is mfoster so I’ll need a folder setup on a network share called mfoster.

I’m not going to repeat every step, I’m basically starting at Step 3 from the first example.

### Step 1: Create a New Drive Mapped drive

Here are the drive map settings for mapping a drive for an individual user

The %UserName% is a variable that will match the user’s logon name.

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Personal-Drive.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Personal-Drive.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Personal-Drive.jpg)

Just to be clear you must have folders setup on a network share that matches the location and users logon name.

My file server is file1, the share is users and in the user’s folder is a folder for each user. Screenshot below of users folder on file1 server.

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-File-Servers-Users.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-File-Servers-Users.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-File-Servers-Users.jpg)

That is it.

Just have the user log off and back on and it should map the M drive

[![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Personal-Drive-2.jpg)

![](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Personal-Drive-2.jpg)

](https://activedirectorypro.com/wp-content/uploads/2018/07/GPO-Map-Personal-Drive-2.jpg)

Perfect! Now the user is mapping a department drive and a personal drive.

## Final Thoughts

As you can see mapping drives with group policy is very easy. It doesn’t require any scripting experience, it’s just a matter of a few clicks and select your desired settings.

If you are still using logon scripts follow the steps in this guide and replace them with Group Policy. The biggest challenge is just finding the time to switch them over.

Now it’s time to switch over those logon scripts.

**Related Posts:**

[List NTFS Permissions on all folders](https://activedirectorypro.com/list-ntfs-permissions-all-folders/)

## Recommended Tool: Permissions Analyzer for Active Directory

This FREE tool lets you get instant visibility into user and group permissions and allows you to quickly check user or group permissions for files, network, and folder shares.

You can analyze user permissions based on an individual user or group membership.

This is a Free tool, [download your copy here](https://www.solarwinds.com/free-tools/permissions-analyzer-for-active-directory/registration?a_aid=BIZ-PAP-ADP&a_bid=06714014&CMP=BIZ-PAP-ADP-XXXermissions-PAFT-DL).